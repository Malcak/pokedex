data "aws_iam_role" "ecs_task_execution_role" {
  name = "${var.project}-ecs-task-execution-role"
}

data "aws_iam_instance_profile" "ecs_instance_profile" {
  name = "${var.project}-ecs-instance-profile"
}

data "aws_iam_role" "prometheus" {
  name = "${var.project}-prometheus"
}

data "aws_iam_instance_profile" "prometheus_profile" {
  name = "${var.project}-prometheus-instance-profile"
}

data "aws_ami" "latest_amazonlinux_ecs" {
  owners      = ["amazon"]
  most_recent = true
  filter {
    name   = "name"
    values = ["amzn2-ami-ecs-hvm-*-x86_64-*"]
  }
}

resource "aws_ecs_cluster" "main" {
  name = "${var.project}-${var.environment}-cluster"

  tags = {
    "Name" : "${var.project}-${var.environment}-ecscluster"
  }
}

resource "aws_ecs_capacity_provider" "ecsautoscaling" {
  name = "${var.project}-${var.environment}-capacity-provider"

  auto_scaling_group_provider {
    auto_scaling_group_arn = aws_autoscaling_group.pokedex.arn
  }

  tags = {
    "Name" : "${var.project}-${var.environment}-capacity-provider"
  }
}

resource "aws_ecs_cluster_capacity_providers" "clustercp" {
  cluster_name       = aws_ecs_cluster.main.name
  capacity_providers = [aws_ecs_capacity_provider.ecsautoscaling.name]
}

resource "aws_ecs_task_definition" "monitoring_td" {
  family                   = "${var.project}-${var.environment}-metric-exporter-td"
  requires_compatibilities = ["EC2"]
  execution_role_arn       = data.aws_iam_role.ecs_task_execution_role.arn
  task_role_arn            = data.aws_iam_role.ecs_task_execution_role.arn
  cpu                      = "512"
  memory                   = "512"

  container_definitions = jsonencode([
    {
      "name" : "node-exporter",
      "image" : "prom/node-exporter:v1.5.0",
      "cpu" : 256,
      "memory" : 256,
      "memoryReservation" : 128,
      "portMappings" : [
        {
          "containerPort" : 9100,
          "hostPort" : 9100,
          "protocol" : "tcp"
        }
      ],
      "essential" : true
    },
    {
      "name" : "cadvisor-exporter",
      "image" : "gcr.io/cadvisor/cadvisor:v0.46.0",
      "cpu" : 256,
      "memory" : 256,
      "memoryReservation" : 128,
      "portMappings" : [
        {
          "containerPort" : 8080,
          "hostPort" : 9200,
          "protocol" : "tcp"
        }
      ],
      "essential" : true,
      "mountPoints" : [
        {
          "sourceVolume" : "root",
          "containerPath" : "/rootfs",
          "readOnly" : true
        },
        {
          "sourceVolume" : "sys",
          "containerPath" : "/sys",
          "readOnly" : true
        },
        {
          "sourceVolume" : "var_run",
          "containerPath" : "/var/run",
          "readOnly" : true
        },
        {
          "sourceVolume" : "var_lib_docker",
          "containerPath" : "/var/lib/docker",
          "readOnly" : true
        },
        {
          "sourceVolume" : "dev_disk",
          "containerPath" : "/dev/disk",
          "readOnly" : true
        }
      ],
      "privileged" : true,
      "readonlyRootFilesystem" : false
    }
  ])

  volume {
    name      = "root"
    host_path = "/"
  }

  volume {
    name      = "sys"
    host_path = "/sys"
  }

  volume {
    name      = "var_run"
    host_path = "/var/run"
  }

  volume {
    name      = "var_lib_docker"
    host_path = "/var/lib/docker"
  }

  volume {
    name      = "dev_disk"
    host_path = "/dev/disk"
  }

  tags = {
    "Name" : "${var.project}-${var.environment}-metric-exporter-td"
  }
}

resource "aws_ecs_task_definition" "pokedex_ecs_td" {
  family                   = "${var.project}-${var.environment}-td"
  network_mode             = "awsvpc"
  requires_compatibilities = ["EC2"]
  execution_role_arn       = data.aws_iam_role.ecs_task_execution_role.arn
  task_role_arn            = data.aws_iam_role.ecs_task_execution_role.arn
  cpu                      = "256"
  memory                   = "256"

  container_definitions = jsonencode([
    {
      name        = "${var.project}-${var.environment}-container"
      image       = "${var.ecr_repository_url}:${var.image_tag}"
      cpu         = 256
      memory      = 256
      networkMode = "awsvpc"
      portMappings = [
        {
          containerPort = 3000
          hostPort      = 3000
        }
      ]

      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group" : "${var.project}-${var.environment}-cwlg",
          "awslogs-region" : "${var.region}",
          "awslogs-stream-prefix" : "ecs"
        }
      }
      essential = true
    }
  ])

  tags = {
    "Name" : "${var.project}-${var.environment}-td"
  }
}

resource "aws_ecs_service" "monitoring" {
  name                  = "${var.project}-${var.environment}-metric-exporter-service"
  cluster               = aws_ecs_cluster.main.id
  task_definition       = aws_ecs_task_definition.monitoring_td.arn
  scheduling_strategy   = "DAEMON"
  wait_for_steady_state = true

  deployment_controller {
    type = "ECS"
  }

  tags = {
    "Name" : "${var.project}-${var.environment}-metric-exporter-service"
  }
}

resource "aws_ecs_service" "pokedex" {
  name                               = "${var.project}-${var.environment}-service"
  cluster                            = aws_ecs_cluster.main.id
  task_definition                    = aws_ecs_task_definition.pokedex_ecs_td.arn
  desired_count                      = var.app_count
  deployment_maximum_percent         = 200
  deployment_minimum_healthy_percent = 80
  scheduling_strategy                = "REPLICA"

  deployment_controller {
    type = "CODE_DEPLOY"
  }

  network_configuration {
    security_groups = [aws_security_group.pokedex_task_sg.id]
    subnets         = module.network.private_subnets
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.blue.id
    container_name   = "${var.project}-${var.environment}-container"
    container_port   = 3000
  }

  depends_on = [aws_lb_listener.pokedex_lb_listener]

  lifecycle {
    // NOTE: Based on: https://docs.aws.amazon.com/cli/latest/reference/ecs/update-service.html
    // If the network configuration, platform version, or task definition need to be updated, a new AWS CodeDeploy deployment should be created.
    ignore_changes = [
      desired_count,
      load_balancer,
      network_configuration,
      task_definition
    ]
  }

  tags = {
    "Name" : "${var.project}-${var.environment}-ecsservice"
  }
}

resource "aws_launch_template" "front" {
  name_prefix            = "${var.project}-${var.environment}-launchconfig"
  image_id               = data.aws_ami.latest_amazonlinux_ecs.id
  instance_type          = var.instance_type
  vpc_security_group_ids = [aws_security_group.pokedex_task_sg.id, aws_security_group.exporter.id]
  user_data              = base64encode("#!/bin/bash\necho ECS_CLUSTER=${aws_ecs_cluster.main.name} >> /etc/ecs/ecs.config")

  iam_instance_profile {
    arn = data.aws_iam_instance_profile.ecs_instance_profile.arn
  }

  depends_on = [
    aws_security_group.pokedex_task_sg,
    aws_security_group.exporter
  ]
}

resource "aws_autoscaling_group" "pokedex" {
  name                = "${var.project}-${var.environment}-asg"
  vpc_zone_identifier = module.network.private_subnets

  launch_template {
    id = aws_launch_template.front.id
  }

  desired_capacity          = var.app_count
  min_size                  = 2
  max_size                  = 6
  health_check_grace_period = 300
  health_check_type         = "EC2"
}

resource "aws_cloudwatch_log_group" "log_group" {
  name = "${var.project}-${var.environment}-cwlg"
}

resource "aws_instance" "scraper" {
  ami                         = data.aws_ami.latest_amazonlinux_ecs.id
  instance_type               = var.instance_type
  vpc_security_group_ids      = aws_security_group.scraper.*.id
  subnet_id                   = module.network.public_subnets[0]
  iam_instance_profile        = data.aws_iam_instance_profile.prometheus_profile.name
  key_name                    = data.aws_key_pair.key_pair.key_name
  associate_public_ip_address = true

  root_block_device {
    volume_size = 30
    tags = {
      "Name" = "${var.project}-${var.environment}-disk"
    }
  }

  user_data = templatefile("../user-data/launch-prometheus.tpl", {
    region   = "${var.region}"
    asg_name = "${aws_autoscaling_group.pokedex.name}"
    role_arn = "${data.aws_iam_role.prometheus.arn}"
    env      = "${var.environment}"
  })

  tags = {
    "Name" = "${var.project}-${var.environment}-prometheus"
  }
}

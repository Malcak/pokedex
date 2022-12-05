data "aws_iam_role" "ecs_task_execution_role" {
  name = "${var.project}-ecs-task-execution-role"
}

data "aws_iam_instance_profile" "ecs_instance_profile" {
  name = "${var.project}-ecs-instance-profile"
}

data "aws_ami" "latest_amazonlinux_ecs" {
  owners      = ["amazon"]
  most_recent = true
  filter {
    name   = "name"
    values = ["amzn2-ami-ecs-hvm-*-x86_64-*"]
  }
}

resource "aws_ecs_task_definition" "pokedex_ecs_td" {
  family                   = "${var.project}-${var.environment}-td"
  network_mode             = "awsvpc"
  requires_compatibilities = ["EC2"]
  execution_role_arn       = data.aws_iam_role.ecs_task_execution_role.arn
  task_role_arn            = data.aws_iam_role.ecs_task_execution_role.arn

  container_definitions = jsonencode([
    {
      name        = "${var.project}-${var.environment}-container"
      image       = "${var.ecr_repository_url}:${var.image_tag}"
      cpu         = 256
      memory      = 512
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

resource "aws_ecs_cluster" "main" {
  name = "${var.project}-${var.environment}-cluster"

  tags = {
    "Name" : "${var.project}-${var.environment}-ecscluster"
  }
}

resource "aws_ecs_service" "pokedex" {
  name                               = "${var.project}-${var.environment}-service"
  cluster                            = aws_ecs_cluster.main.id
  task_definition                    = aws_ecs_task_definition.pokedex_ecs_td.arn
  desired_count                      = var.app_count
  deployment_maximum_percent         = 100
  deployment_minimum_healthy_percent = 0
  scheduling_strategy                = "REPLICA"
  wait_for_steady_state              = true

  deployment_controller {
    type = "ECS"
  }

  network_configuration {
    security_groups = [aws_security_group.pokedex_task_sg.id]
    subnets         = module.network.private_subnets
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.pokedex_tg.id
    container_name   = "${var.project}-${var.environment}-container"
    container_port   = 3000
  }

  depends_on = [aws_lb_listener.pokedex_lb_listener]

  tags = {
    "Name" : "${var.project}-${var.environment}-ecsservice"
  }
}

resource "aws_launch_template" "front" {
  name_prefix            = "${var.project}-${var.environment}-launchconfig"
  image_id               = data.aws_ami.latest_amazonlinux_ecs.id
  instance_type          = var.instance_type
  vpc_security_group_ids = [aws_security_group.pokedex_task_sg.id]
  user_data              = base64encode("#!/bin/bash\necho ECS_CLUSTER=${aws_ecs_cluster.main.name} >> /etc/ecs/ecs.config")

  iam_instance_profile {
    arn = data.aws_iam_instance_profile.ecs_instance_profile.arn
  }

  depends_on = [
    aws_security_group.pokedex_task_sg
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
  max_size                  = 10
  health_check_grace_period = 300
  health_check_type         = "EC2"
}

resource "aws_cloudwatch_log_group" "log_group" {
  name = "${var.project}-${var.environment}-cwlg"
}

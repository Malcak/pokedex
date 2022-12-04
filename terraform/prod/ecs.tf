data "aws_iam_role" "ecs_task_execution_role" {
  name = "pokedex-ecs-task-execution-role"
}

resource "aws_ecs_task_definition" "pokedex_ecs_td" {
  family                   = "${var.project}-${var.environment}-td"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = 256
  memory                   = 512
  execution_role_arn       = data.aws_iam_role.ecs_task_execution_role.arn

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
  name            = "${var.project}-${var.environment}-service"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.pokedex_ecs_td.arn
  desired_count   = var.app_count
  launch_type     = "FARGATE"

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

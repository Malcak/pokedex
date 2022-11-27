resource "aws_ecs_task_definition" "pokedex_ecs_td" {
  family                   = "pokedex"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = 256
  memory                   = 512
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn

  container_definitions = <<DEFINITION
  [
    {
      "image": "${var.ecr_repository_url}:${var.image_tag}",
      "cpu": 256,
      "memory": 512,
      "name": "pokedex",
      "networkMode": "awsvpc",
      "portMappings": [
        {
          "containerPort": 3000,
          "hostPort": 3000
        }
      ]
    }
  ]
  DEFINITION
}

resource "aws_ecs_cluster" "main" {
  name = "pokedex-cluster"
}

resource "aws_ecs_service" "pokedex" {
  name            = "pokedex-service"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.pokedex_ecs_td.arn
  desired_count   = var.app_count
  launch_type     = "FARGATE"

  network_configuration {
    security_groups = [aws_security_group.pokedex_task_sg.id]
    subnets         = aws_subnet.private.*.id
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.pokedex_tg.id
    container_name   = "pokedex"
    container_port   = 3000
  }

  depends_on = [aws_lb_listener.pokedex_lb_listener]
}

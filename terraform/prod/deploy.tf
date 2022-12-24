data "aws_iam_role" "codedeploy_role" {
  name = "${var.project}-codedeploy-role"
}

resource "aws_codedeploy_app" "pokedex" {
  compute_platform = "ECS"
  name             = "${var.project}-${var.environment}-app"

  tags = {
    "Name" = "${var.project}-${var.environment}-app"
  }
}

resource "aws_codedeploy_deployment_config" "pokedex" {
  deployment_config_name = "${var.project}-${var.environment}-dc"
  compute_platform       = "ECS"

  traffic_routing_config {
    type = "TimeBasedCanary"

    time_based_canary {
      interval   = 5
      percentage = 10
    }
  }
}

resource "aws_codedeploy_deployment_group" "pokedex" {
  app_name               = aws_codedeploy_app.pokedex.name
  deployment_group_name  = "${var.project}-${var.environment}-dg"
  deployment_config_name = aws_codedeploy_deployment_config.pokedex.id
  service_role_arn       = data.aws_iam_role.codedeploy_role.arn

  auto_rollback_configuration {
    enabled = true
    events  = ["DEPLOYMENT_FAILURE"]
  }

  # autoscaling_groups = aws_autoscaling_group.pokedex

  blue_green_deployment_config {
    deployment_ready_option {
      action_on_timeout = "CONTINUE_DEPLOYMENT"
    }

    terminate_blue_instances_on_deployment_success {
      action = "TERMINATE"
    }
  }

  deployment_style {
    deployment_option = "WITH_TRAFFIC_CONTROL"
    deployment_type   = "BLUE_GREEN"
  }

  ecs_service {
    cluster_name = aws_ecs_cluster.main.name
    service_name = aws_ecs_service.pokedex.name
  }

  load_balancer_info {
    target_group_pair_info {
      prod_traffic_route {
        listener_arns = [aws_lb_listener.pokedex_lb_listener.arn]
      }

      target_group {
        name = aws_lb_target_group.blue.name
      }

      target_group {
        name = aws_lb_target_group.green.name
      }
    }
  }

  # trigger_configuration {

  # }

  tags = {
    "Name" = "${var.project}-${var.environment}-dg"
  }
}

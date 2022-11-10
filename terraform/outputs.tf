output "ecr_repository_url" {
  value = "${data.aws_caller_identity.current.account_id}.dkr.ecr.${var.region}.amazonaws.com"
}

output "ecr_username" {
  value     = data.aws_ecr_authorization_token.token.user_name
  sensitive = true
}

output "ecr_password" {
  value     = data.aws_ecr_authorization_token.token.password
  sensitive = true
}

output "load_balancer_ip" {
  value = aws_lb.default.dns_name
}

output "ecs_cluster_arn" {
  value = aws_ecs_cluster.main.arn
}

output "ecs_service_name" {
  value = aws_ecs_service.pokedex.name
}

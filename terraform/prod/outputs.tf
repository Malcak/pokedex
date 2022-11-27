output "load_balancer_ip" {
  value = aws_lb.default.dns_name
}

output "ecs_cluster_arn" {
  value = aws_ecs_cluster.main.arn
}

output "ecs_service_name" {
  value = aws_ecs_service.pokedex.name
}

resource "aws_ecr_repository" "pokedex_repository" {
  name = "${var.project}-repository"
}

output "ecr_repository_url" {
  value = aws_ecr_repository.pokedex_repository.repository_url
}

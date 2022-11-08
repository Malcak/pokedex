output "ecr_repository_url" {
  value = "${data.aws_caller_identity.current.account_id}.dkr.ecr.${var.region}.amazonaws.com"
}

output "ecr_username" {
  value = data.aws_ecr_authorization_token.token.user_name
  sensitive = true
}

output "ecr_password" {
  value = data.aws_ecr_authorization_token.token.password
  sensitive = true
}

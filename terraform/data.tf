data "aws_ecr_authorization_token" "token" {}

data "aws_caller_identity" "current" {}

data "aws_availability_zones" "available_zones" {
  state = "available"
}

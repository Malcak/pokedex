terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.38.0"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "4.0.4"
    }
  }

  backend "s3" {
    bucket         = "malakk-pokedex-prod-us-east-1-terraform-state"
    key            = "prod/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "malakk-pokedex-prod-us-east-1-terraform-locks"
    encrypt        = true
  }
}

provider "aws" {
  region = var.region

  default_tags {
    tags = {
      "Environment" = var.environment
      "Project"     = var.project
    }
  }
}

provider "tls" {}

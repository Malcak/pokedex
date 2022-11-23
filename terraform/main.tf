terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.38.0"
    }
  }

  backend "s3" {
    bucket         = "pokedex-terraform-state"
    key            = "global/s3/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "pokedex-terraform-locks"
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

module "backend" {
  source  = "./modules/tf-s3-backend"
  project = var.project
}

module "ecr" {
  source  = "./modules/ecr"
  project = var.project
}

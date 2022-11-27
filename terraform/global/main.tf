terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.38.0"
    }
  }

  backend "s3" {
    bucket         = "pokedex-global-terraform-state"
    key            = "global/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "pokedex-global-terraform-locks"
    encrypt        = true
  }
}

provider "aws" {
  region = var.region

  default_tags {
    tags = {
      "Environment" = "global"
      "Project"     = var.project
    }
  }
}

module "backend" {
  count       = length(var.environments)
  source      = "../modules/tf-backend"
  project     = var.project
  environment = var.environments[count.index]
}

module "ecr" {
  source  = "../modules/ecr"
  project = var.project
}

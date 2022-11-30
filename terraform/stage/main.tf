terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.38.0"
    }
  }

  backend "s3" {
    bucket         = "pokedex-stage-terraform-state"
    key            = "stage/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "pokedex-stage-terraform-locks"
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

module "network" {
  source                    = "../modules/network"
  environment               = var.environment
  project                   = var.project
  vpc_cidr                  = var.vpc_cidr
  number_redundant_networks = 2
}

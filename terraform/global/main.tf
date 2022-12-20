terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.38.0"
    }
  }

  backend "s3" {
    bucket         = "malakk-pokedex-global-us-east-1-terraform-state"
    key            = "global/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "malakk-pokedex-global-us-east-1-terraform-locks"
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

data "aws_iam_account_alias" "current" {}

module "backend" {
  count          = length(var.environments)
  source         = "github.com/Malcak/terraform-s3-backend.git"
  bucket_purpose = "${var.project}-${var.environments[count.index]}"
  accout_alias   = data.aws_iam_account_alias.current.account_alias
  region         = var.region
}

module "ecr" {
  source  = "../modules/ecr"
  project = var.project
}

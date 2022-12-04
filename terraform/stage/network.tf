resource "aws_vpc" "default" {
  cidr_block = var.vpc_cidr

  tags = {
    "Name" : "${var.project}-${var.environment}-vpc"
  }
}

resource "aws_internet_gateway" "gateway" {
  vpc_id = aws_vpc.default.id

  tags = {
    "Name" : "${var.project}-${var.environment}-ig"
  }
}

resource "aws_route" "internet_access" {
  route_table_id         = aws_vpc.default.main_route_table_id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.gateway.id
}

module "network" {
  source          = "../modules/two-tier"
  environment     = var.environment
  project         = var.project
  vpc_id          = aws_vpc.default.id
  vpc_cidr        = aws_vpc.default.cidr_block
  redundant_zones = 2
}

data "aws_availability_zones" "available_zones" {
  state = "available"
}

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

resource "aws_subnet" "private" {
  count             = var.number_redundant_networks
  cidr_block        = cidrsubnet(aws_vpc.default.cidr_block, 8, count.index)
  availability_zone = data.aws_availability_zones.available_zones.names[count.index]
  vpc_id            = aws_vpc.default.id

  tags = {
    "Name" : "${var.project}-${var.environment}-privatesubnet"
  }
}

resource "aws_subnet" "public" {
  count                   = var.number_redundant_networks
  cidr_block              = cidrsubnet(aws_vpc.default.cidr_block, 8, 2 + count.index)
  availability_zone       = data.aws_availability_zones.available_zones.names[count.index]
  vpc_id                  = aws_vpc.default.id
  map_public_ip_on_launch = true

  tags = {
    "Name" : "${var.project}-${var.environment}-publicsubnet"
  }
}

resource "aws_eip" "gateway" {
  count      = var.number_redundant_networks
  vpc        = true
  depends_on = [aws_internet_gateway.gateway]

  tags = {
    "Name" : "${var.project}-${var.environment}-eip"
  }
}

resource "aws_nat_gateway" "gateway" {
  count         = var.number_redundant_networks
  allocation_id = element(aws_eip.gateway.*.id, count.index)
  subnet_id     = element(aws_subnet.public.*.id, count.index)

  tags = {
    "Name" : "${var.project}-${var.environment}-nat"
  }
}

resource "aws_route_table" "private" {
  count  = var.number_redundant_networks
  vpc_id = aws_vpc.default.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = element(aws_nat_gateway.gateway.*.id, count.index)
  }

  tags = {
    "Name" : "${var.project}-${var.environment}-rt"
  }
}

resource "aws_route_table_association" "private" {
  count          = var.number_redundant_networks
  subnet_id      = element(aws_subnet.private.*.id, count.index)
  route_table_id = element(aws_route_table.private.*.id, count.index)
}

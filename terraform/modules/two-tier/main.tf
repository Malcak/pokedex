data "aws_availability_zones" "available_zones" {
  state = "available"
}

resource "aws_subnet" "private" {
  count             = var.redundant_zones
  cidr_block        = cidrsubnet(var.vpc_cidr, 8, count.index)
  availability_zone = data.aws_availability_zones.available_zones.names[count.index]
  vpc_id            = var.vpc_id

  tags = {
    "Name" : "${var.project}-${var.environment}-privatesubnet"
  }
}

resource "aws_subnet" "public" {
  count                   = var.redundant_zones
  cidr_block              = cidrsubnet(var.vpc_cidr, 8, 2 + count.index)
  availability_zone       = data.aws_availability_zones.available_zones.names[count.index]
  vpc_id                  = var.vpc_id
  map_public_ip_on_launch = true

  tags = {
    "Name" : "${var.project}-${var.environment}-publicsubnet"
  }
}

resource "aws_eip" "gateway" {
  count = var.redundant_zones
  vpc   = true

  tags = {
    "Name" : "${var.project}-${var.environment}-eip"
  }
}

resource "aws_nat_gateway" "gateway" {
  count         = var.redundant_zones
  allocation_id = element(aws_eip.gateway.*.id, count.index)
  subnet_id     = element(aws_subnet.public.*.id, count.index)

  tags = {
    "Name" : "${var.project}-${var.environment}-nat"
  }
}

resource "aws_route_table" "private" {
  count  = var.redundant_zones
  vpc_id = var.vpc_id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = element(aws_nat_gateway.gateway.*.id, count.index)
  }

  tags = {
    "Name" : "${var.project}-${var.environment}-rt"
  }
}

resource "aws_route_table_association" "private" {
  count          = var.redundant_zones
  subnet_id      = element(aws_subnet.private.*.id, count.index)
  route_table_id = element(aws_route_table.private.*.id, count.index)
}

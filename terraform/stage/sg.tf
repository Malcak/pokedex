resource "aws_security_group" "lb_sg" {
  name   = "${var.project}-${var.environment}-alb-security-group"
  vpc_id = aws_vpc.default.id

  ingress {
    protocol    = "tcp"
    from_port   = 80
    to_port     = 80
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    "Name" : "${var.project}-${var.environment}-lbsg"
  }
}

resource "aws_security_group" "pokedex_task_sg" {
  name   = "${var.project}-${var.environment}-task-security-group"
  vpc_id = aws_vpc.default.id

  ingress {
    protocol        = "tcp"
    from_port       = 3000
    to_port         = 3000
    security_groups = [aws_security_group.lb_sg.id]
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    "Name" : "${var.project}-${var.environment}-tdsg"
  }
}

resource "aws_security_group" "scraper" {
  name   = "${var.project}-${var.environment}-scraper-security-group"
  vpc_id = aws_vpc.default.id

  dynamic "ingress" {
    for_each = var.scraper_ports
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = var.scraper_allowed_ingress_cidr_blocks
    }
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    "Name" : "${var.project}-${var.environment}-scraper-sg"
  }
}

resource "aws_security_group" "exporter" {
  name   = "${var.project}-${var.environment}-exporter-security-group"
  vpc_id = aws_vpc.default.id

  dynamic "ingress" {
    for_each = var.exporter_ports
    content {
      from_port       = ingress.value
      to_port         = ingress.value
      protocol        = "tcp"
      security_groups = [aws_security_group.scraper.id]
    }
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    "Name" : "${var.project}-${var.environment}-exporter-sg"
  }
}

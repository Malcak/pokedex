resource "aws_security_group" "lb_sg" {
  name   = "${var.project}-${var.environment}-alb-security-group"
  vpc_id = module.network.vpc_id

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
  vpc_id = module.network.vpc_id

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

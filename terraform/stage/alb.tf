resource "aws_lb" "default" {
  name            = "${var.project}-${var.environment}-lb"
  subnets         = module.network.public_subnets
  security_groups = [aws_security_group.lb_sg.id]

  tags = {
    "Name" : "${var.project}-${var.environment}-lb"
  }
}

resource "aws_lb_target_group" "pokedex_tg" {
  name        = "${var.project}-${var.environment}-target-group"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = aws_vpc.default.id
  target_type = "ip"

  tags = {
    "Name" : "${var.project}-${var.environment}-tg"
  }
}

resource "aws_lb_listener" "pokedex_lb_listener" {
  load_balancer_arn = aws_lb.default.id
  port              = "80"
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_lb_target_group.pokedex_tg.id
    type             = "forward"
  }

  tags = {
    "Name" : "${var.project}-${var.environment}-lblistener"
  }
}

# Security Group

resource "aws_security_group" "lb_sg" {
  name   = "${var.app_name}-lb-sg"
  vpc_id = var.vpc_id

  ingress {
    protocol         = "tcp"
    from_port        = 80
    to_port          = 80
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    protocol         = "tcp"
    from_port        = 443
    to_port          = 443
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    protocol         = "-1"
    from_port        = 0
    to_port          = 0
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}

# Load Balancer

resource "aws_lb" "app_lb" {
  name               = "${var.app_name}-lb"
  internal           = false
  load_balancer_type = "application"

  security_groups = [aws_security_group.lb_sg.id]
  subnets         = var.lb_subnets 
}

# Target Group

resource "aws_alb_target_group" "app_tg" {
  name        = "${aws_lb.app_lb.name}-tg"
  port        = 80
  protocol    = "HTTP"
  vpc_id      =  var.vpc_id
  target_type = "ip"
}

# Listeners

resource "aws_alb_listener" "app_http" {
  load_balancer_arn = aws_lb.app_lb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port = aws_alb_listener.app_https.port
      protocol = aws_alb_listener.app_https.protocol
      status_code = "HTTP_301"
    }
  }
}

resource "aws_alb_listener" "app_https" {
  load_balancer_arn = aws_lb.app_lb.arn
  port              = 443
  protocol          = "HTTPS"

  certificate_arn = data.aws_acm_certificate.app_cert.arn
  ssl_policy = "ELBSecurityPolicy-2016-08"

  default_action {
    target_group_arn = aws_alb_target_group.app_tg.arn
    type             = "forward"
  }
}


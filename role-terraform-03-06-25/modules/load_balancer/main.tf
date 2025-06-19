locals {
  constant_alb_tags = {
    Environment = var.Environment
    ManagedBy   = "Terraform"
  }
}
resource "aws_lb" "load_balancer" {
  name                       = "${var.customer_name}-${var.Environment}-alb"
  internal                   = var.internal
  load_balancer_type         = "application"
  enable_deletion_protection = true
  security_groups            = [aws_security_group.tf-sg.id]
  subnets                    = var.private_subnet_ids
    tags = merge(
    local.constant_alb_tags,
    var.lb_tags
  )
}


resource "aws_lb_listener" "lis443" {
  load_balancer_arn = aws_lb.load_balancer.arn
  port              = var.listener-port
  protocol          = var.listener-protocol
  #ssl_policy        = "ELBSecurityPolicy-TLS-1-2-Ext-2018-06"
  #certificate_arn   = aws_acm_certificate.example.arn ##need to pass as variable after testing
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg.arn

  }
}

resource "aws_lb_target_group" "tg" {
  name     = "${var.customer_name}-${var.Environment}-target-group"
  port     = var.target-group-port
  protocol = var.target-gorup-protocol
  vpc_id   = var.vpc_id
  health_check {
    path                = "/healthz"  
    protocol            = "HTTP"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 3
    unhealthy_threshold = 2
  }
}

resource "aws_security_group" "tf-sg" {
  vpc_id      = var.vpc_id
  name        = "${var.customer_name}-${var.Environment}-alb-sg"
  description = "security group for alb"

    ingress {
    description = "Allow HTTP traffic from within the VPC"
    from_port   = var.target-group-port
    to_port     = var.target-group-port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# uncomment this when you have a existing autoscalng group 

#resource "aws_autoscaling_attachment" "test" {
#  autoscaling_group_name = var.autoscaling-group-name
#  lb_target_group_arn   = aws_lb_target_group.tg.arn
#}

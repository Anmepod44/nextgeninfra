resource "aws_lb" "app_lb" {
  name               = "application-load-balancer"
  load_balancer_type = "application"
  subnets            = module.vpc.public_subnets
  idle_timeout       = 60
  security_groups    = [module.lb_security_group.security_group_id]
}

resource "aws_alb_listener" "l_80" {
  load_balancer_arn = aws_lb.app_lb.arn
  port              = 80
  protocol          = "HTTP"
  default_action {
    type = "redirect"
    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

resource "aws_alb_listener" "l_8080" {
  load_balancer_arn = aws_lb.app_lb.id
  port              = 8080
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg[1].arn
  }
}

# Uncomment and replace the certificate ARN to use HTTPS on port 443
# resource "aws_alb_listener" "l_443" {
#   load_balancer_arn = aws_lb.app_lb.arn
#   port              = 443
#   protocol          = "HTTPS"
#   certificate_arn   = var.certificate_arn  # Add this as a variable in variables.tf
#   default_action {
#     type             = "forward"
#     target_group_arn = aws_lb_target_group.tg[0].arn
#   }
# }

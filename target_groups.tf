locals {
  target_groups = ["green", "blue"]
}

resource "aws_lb_target_group" "tg" {
  count       = length(local.target_groups)
  name        = "${var.lb_target_group_name}-${local.target_groups[count.index]}"
  port        = 443
  protocol    = "HTTP"
  target_type = "instance"
  vpc_id      = module.vpc.vpc_id  # Using the VPC ID from the VPC module

  health_check {
    matcher = "200,301,302,404"
    path    = "/"
  }
}

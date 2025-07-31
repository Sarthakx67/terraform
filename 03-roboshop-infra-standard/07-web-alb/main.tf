# creating application load balancer to distribute traffic between components
resource "aws_lb" "web_alb" {
  name               = "${var.project_name}-${var.common_tags.component}"
  internal           = false # this is a public load balancer so will keep internal as false
  load_balancer_type = "application"
  security_groups    = [data.aws_ssm_parameter.web_alb_sg_id.value]
  subnets            = split(",",data.aws_ssm_parameter.public_subnet_ids.value)
#   enable_deletion_protection = true to prevent accedental deletion
  tags = var.common_tags
}

# this will create listners
resource "aws_lb_listener" "web_alb-listner" {
  load_balancer_arn = aws_lb.web_alb.arn
  port              = "443"
  protocol          = "HTTPS"
  # this will add one listner on port no 443 and one default rule
  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "This is Fixed Response as app alb"
      status_code  = "200"
    }
  }
}

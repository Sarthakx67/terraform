resource "aws_lb_target_group" "catalogue_tg" {
  name     = "${var.project_name}-${var.common_tags.component}"
  port     = 8080
  protocol = "HTTP"
  vpc_id   = data.aws_ssm_parameter.vpc_id.value
  health_check {
    enabled = true # enable health check
    healthy_threshold   = 2 # threshold to pass health check when healthy_threshold = 2
    interval            = 15 # frequency of health check
    unhealthy_threshold = 3 # fail criteria
    timeout             = 5 # max time to wait
    path                = "/health" # path to health check
    port                = 8080 
    matcher             = "200-299" # range of acceptable output 
    protocol            = "HTTP" 
  }
}   

resource "aws_launch_template" "catalogue" {
  name     = "${var.project_name}-${var.common_tags.component}"
  
  image_id = data.aws_ami.roboshop-ami.id
  instance_initiated_shutdown_behavior = "terminate"
  instance_type = "t2.micro"

  vpc_security_group_ids = [data.aws_ssm_parameter.catalogue_sg_id.value]
  
  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "Catalogue"
    }
  }
}
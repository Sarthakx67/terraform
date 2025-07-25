module "vpn_sg" {
  source = "../../02-terraform-modules-projects/03-terraform-aws-security-group"
  sg_name = "roboshop-vpn"
  sg_description = "allowing all ports from home ip"
  project_name = var.project_name
  vpc_id = data.aws_vpc.default.id
  common_tags  = merge(
    var.common_tags,
    {
        component = "vpn_sg"
        Name = "Vpn-sg"
    }
  )
}
module "mongodb_sg" {
  source = "../../02-terraform-modules-projects/03-terraform-aws-security-group"
  sg_name = "mongodb"
  sg_description = "allowing traffic"
  project_name = var.project_name
  vpc_id = data.aws_ssm_parameter.roboshop-vpc-id.value
  common_tags  = merge(
    var.common_tags,
    {
        component = "mongodb_sg"
    }
  )
}
module "catalogue_sg" {
  source = "../../02-terraform-modules-projects/03-terraform-aws-security-group"
  sg_name = "catalogue_sg"
  sg_description = "allowing traffic"
  project_name = var.project_name
  vpc_id = data.aws_ssm_parameter.roboshop-vpc-id.value
  common_tags  = merge(
    var.common_tags,
    {
        component = "catalogue_sg"
    }
  )
}
module "app_alb_sg" {
  source = "../../02-terraform-modules-projects/03-terraform-aws-security-group"
  sg_name = "app_alb_sg"
  sg_description = "allowing traffic"
  project_name = var.project_name
  vpc_id = data.aws_ssm_parameter.roboshop-vpc-id.value
  common_tags  = merge(
    var.common_tags,
    {
        component = "app_alb_sg"
    }
  )
}
module "web_sg" {
  source = "../../02-terraform-modules-projects/03-terraform-aws-security-group"
  sg_name = "web_sg"
  sg_description = "allowing traffic"
  project_name = var.project_name
  vpc_id = data.aws_ssm_parameter.roboshop-vpc-id.value
  common_tags  = merge(
    var.common_tags,
    {
        component = "web_sg"
    }
  )
}
module "web_alb_sg" {
  source = "../../02-terraform-modules-projects/03-terraform-aws-security-group"
  sg_name = "web_alb_sg"
  sg_description = "allowing traffic"
  project_name = var.project_name
  vpc_id = data.aws_ssm_parameter.roboshop-vpc-id.value
  common_tags  = merge(
    var.common_tags,
    {
        component = "web_alb_sg"
    }
  )
}
resource "aws_security_group_rule" "vpn" {
  security_group_id = module.vpn_sg.security_group_id
  type = "ingress"
  cidr_blocks   = ["${chomp(data.http.myip.response_body)}/32"]
  from_port   = 0
  protocol = "tcp"
  to_port     = 65535
}
resource "aws_security_group_rule" "mongodb_vpn" {
  # providing mongodb sg 
  security_group_id = module.mongodb_sg.security_group_id
  type = "ingress"
  # source is the main sg to connect mongodb sg to access connection from
  source_security_group_id = module.vpn_sg.security_group_id
  from_port   = 22
  protocol = "tcp"
  to_port     = 22
}
resource "aws_security_group_rule" "mongodb_catalogue" {
  # providing mongodb sg 
  security_group_id = module.mongodb_sg.security_group_id
  type = "ingress"
  # source is the main sg to connect mongodb sg to access connection from
  source_security_group_id = module.catalogue_sg.security_group_id 
  from_port   = 27017
  protocol = "tcp"
  to_port     = 27017
}
resource "aws_security_group_rule" "catalogue_vpn" {
  # providing sg 
  security_group_id = module.catalogue_sg.security_group_id
  type = "ingress"
  # source is the main sg to connect sg to access connection from
  source_security_group_id = module.vpn_sg.security_group_id
  from_port   = 22
  protocol = "tcp"
  to_port     = 22
}
resource "aws_security_group_rule" "catalogue_app_alb" {
  # providing  sg 
  security_group_id = module.catalogue_sg.security_group_id
  type = "ingress"
  # source is the main sg to connect  sg to access connection from
  source_security_group_id = module.app_alb_sg.security_group_id
  from_port   = 8080
  protocol = "tcp"
  to_port     = 8080 
}
resource "aws_security_group_rule" "app_alb_vpn" {
  # providing  sg 
  security_group_id = module.app_alb_sg.security_group_id
  type = "ingress"
  # source is the main sg to connect  sg to access connection from
  source_security_group_id = module.vpn_sg.security_group_id
  from_port   = 22
  protocol = "tcp"
  to_port     = 22
}
resource "aws_security_group_rule" "app_alb_web" {
  # providing  sg 
  security_group_id = module.app_alb_sg.security_group_id 
  type = "ingress"
  # source is the main sg to connect  sg to access connection from
  source_security_group_id = module.web_sg.security_group_id
  from_port   = 80
  protocol = "tcp"
  to_port     = 80
}
resource "aws_security_group_rule" "web_web_alb" {
  # providing  sg 
  security_group_id = module.web_sg.security_group_id
  type = "ingress"
  # source is the main sg to connect  sg to access connection from
  source_security_group_id = module.web_alb_sg.security_group_id
  from_port   = 80
  protocol = "tcp"
  to_port     = 80
}
resource "aws_security_group_rule" "web_vpn" {
  # providing sg 
  security_group_id = module.vpn_sg.security_group_id
  type = "ingress"
  # source is the main sg to connect  sg to access connection from
  source_security_group_id = module.web_sg.security_group_id
  from_port   = 22
  protocol = "tcp"
  to_port     = 22
}
resource "aws_security_group_rule" "web_alb_internet" {
  # providing  sg 
  security_group_id = module.web_alb_sg.security_group_id
  type = "ingress"
  # source is the main sg to connect  sg to access connection from
  cidr_blocks = ["0.0.0.0/0"]
  from_port   = 80
  protocol = "tcp"
  to_port     = 80
}
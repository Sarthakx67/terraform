# module "vpn_sg" {
#   source = "../../03-terraform-aws-security-group"
#   sg_name = "roboshop-vpn"
#   sg_description = "allowing all ports from home ip"
#   project_name = var.project_name
  
#   vpc_id = data.aws_vpc.default.id
#   common_tags  = var.common_tags
# }

# resource "aws_security_group_rule" "vpn" {
#   security_group_id = module.vpn_sg.security_group_id
#   type = "ingress"
#   cidr_blocks   = ["${chomp(data.http.myip.response_body)}/32"]
#   from_port   = 0
#   protocol = "tcp"
#   to_port     = 65535
# }

resource "aws_instance" "vpn_instance" {
  ami           = data.aws_ami.roboshop-ami.id
  instance_type = "t2.micro"
  key_name = "EC2-key"
  vpc_security_group_ids = [module.vpn_sg.security_group_id]
  subnet_id = data.aws_subnets.default.ids[0]

  tags = {
    Name = "Roboshop-vpn"
  }
}
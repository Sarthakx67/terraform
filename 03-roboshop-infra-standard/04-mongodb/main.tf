# module "mongodb_sg" {
#   source = "../../03-terraform-aws-security-group"
#   sg_name = "mongodb"
#   sg_description = "allowing traffic"
#   project_name = var.project_name
  
#   vpc_id = data.aws_ssm_parameter.roboshop-vpc-id.value
#   common_tags  = var.common_tags
# }
# resource "aws_security_group_rule" "mongodb-vpn" {
#   # providing mongodb sg 
#   security_group_id = module.mongodb_sg.security_group_id
#   type = "ingress"
#   # source is the main sg to connect mongodb sg to access connection from
#   source_security_group_id = data.aws_ssm_parameter.vpn_sg_id.value
#   from_port   = 22
#   protocol = "tcp"
#   to_port     = 22
# }
resource "aws_instance" "mongodb_instance" {
  ami           = data.aws_ami.roboshop-ami.id
  instance_type = "t2.micro"
  key_name = "EC2-key"
  vpc_security_group_ids = [module.mongodb_sg.security_group_id]
  subnet_id = element(split(",", data.aws_ssm_parameter.database_subnet_ids.value),0)
  tags = {
    Name = "mongodb"
  }
}
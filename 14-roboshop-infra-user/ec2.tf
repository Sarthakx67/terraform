module "ec2_instance" {
  for_each = var.instances
  source  = "terraform-aws-modules/ec2-instance/aws"
  ami = "ami-0f918f7e67a3323f0"
  name = "${each.key}"
  instance_type = each.value
  key_name      = "EC2-key"
  vpc_security_group_ids = [local.allow_all_security_group_id]
  subnet_id     = each.key == "Web" ? local.public_subnet_ids[0] : local.private_subnet_ids[0] # this means public subnet in 1a regions
  tags = merge(
    var.common_tags
  )
}
module "ec2_ansible" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  ami = "ami-0f918f7e67a3323f0"
  name = "ansible-server"
  instance_type = "t2.micro"
  key_name      = "EC2-key"
  vpc_security_group_ids = [local.allow_all_security_group_id]
  subnet_id     = local.public_subnet_ids[0] 
  user_data = file("roboshop-ansible.sh")
  tags = merge(
    var.common_tags
  )
}
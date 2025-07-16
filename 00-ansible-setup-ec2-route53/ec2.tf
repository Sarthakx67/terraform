module "ec2_ansible" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  ami = data.aws_ami.roboshop-ami.id
  for_each = var.instances
  name = each.key
  instance_type = "t2.micro"
  key_name      = "EC2-key"
  vpc_security_group_ids = [data.aws_security_group.allow-all.id]
  tags = {
    Name = ""
  }
}
module "records" {
  source  = "terraform-aws-modules/route53/aws//modules/records"
  zone_name = var.zone_name
  for_each = local.ips
  records = [
    {
        name    = "${each.key}"
        type    = "A"
        ttl     = 1
        records = [
            each.key == "web" || each.key == "ansible-server" ? each.value.public_ip : each.value.private_ip
        ]
    }
  ]
}
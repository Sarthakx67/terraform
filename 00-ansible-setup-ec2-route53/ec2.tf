resource "aws_instance" "shell_instance" {
  ami           = data.aws_ami.roboshop-ami.id
  for_each = var.instances
  instance_type = "t2.micro"
  key_name      = "EC2-key"
  # user_data = filebase64("18-web-server.sh")
  tags = {
    Name = "${each.key}"
  }
}
# module "ec2_ansible" {
#   source  = "terraform-aws-modules/ec2-instance/aws"
#   ami = data.aws_ami.roboshop-ami.id
#   for_each = var.instances
#   name = each.key
#   instance_type = "t2.micro"
#   key_name      = "EC2-key"
#   tags = {
#     Name = "${each.key}"
#   }
# }
# module "records" {
#   source  = "terraform-aws-modules/route53/aws//modules/records"
#   zone_name = var.zone_name
#   for_each = local.ips
#   records = [
#     {
#         name    = "${each.key}"
#         type    = "A"
#         ttl     = 1
#         records = [
#             each.key == "web" || each.key == "ansible-server" ? each.value.public_ip : each.value.private_ip
#         ]
#     }
#   ]
# }
resource "aws_instance" "for-loop" {
  ami = var.ec2_ami
  instance_type = var.instance_type
}   
resource "aws_instance" "ec2" {
  ami = var.ami_id
  instance_type = var.instance_type
#   aws_instance resource also has an associate_public_ip_address argument.
#   If this is explicitly set to false, it can override the subnet's setting,
#   or if the subnet doesn't have map_public_ip_on_launch set to true,
#   this needs to be explicitly true on the instance.[5][6][7]
  associate_public_ip_address = true # Explicitly request a public IP
  subnet_id = aws_subnet.public-subnet.id
  vpc_security_group_ids = [aws_security_group.allow_http_ssh.id] 

  key_name = "EC2-key"

  tags = {
    Name = "tf-instance"
  }
}
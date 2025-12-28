resource "aws_instance" "dynamic-website-ec2" {
  ami           = var.ec2_ami
  instance_type = "t3.micro"
  subnet_id = aws_subnet.dynamic-website-subnet.id
  associate_public_ip_address = true
  vpc_security_group_ids = [aws_security_group.allow_http_ssh.id]
  key_name = "EC2-key"
  user_data_base64 = filebase64("dynamic-webiste-config.sh")
  tags = {
    Name = "dynamic-website-ec2"
  }
}
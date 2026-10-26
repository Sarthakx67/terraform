resource "aws_instance" "dynamic-website-ec2" {
  ami           = "ami-02b8269d5e85954ef"
  instance_type = "t3.micro"
  key_name      = "EC2-key"

  subnet_id = aws_subnet.dynamic-website-subnet.id

  vpc_security_group_ids = [
    aws_security_group.allow_http_ssh.id
  ]

  associate_public_ip_address = true

  tags = {
    Name = "dynamic-website-ec2"
  }
}
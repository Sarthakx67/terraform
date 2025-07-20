resource "aws_instance" "Ec2-tf" {
  ami           = var.ec2_ami
  instance_type = var.instance_type
  subnet_id = aws_subnet.Ec2-subnet-vpc-tf.id
  key_name = "EC2-key"
  vpc_security_group_ids = [aws_security_group.allow_http.id]

  tags = {
    Name = "ec2-tf-formation"
  }
}
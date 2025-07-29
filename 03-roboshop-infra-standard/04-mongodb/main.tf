resource "aws_instance" "mongodb_instance" {
  ami           = data.aws_ami.roboshop-ami.id
  instance_type = "t2.micro"
  key_name = "EC2-key"
  vpc_security_group_ids = [data.aws_ssm_parameter.mongodb_sg_id.value]
  subnet_id = element(split(",", data.aws_ssm_parameter.database_subnet_ids.value),0)
  tags = {
    Name = "mongodb"
  }
}
resource "aws_instance" "my-choice-name"{
    ami = data.aws_ami.roboshop-ami.id 
    instance_type = var.instance_type
    security_groups = [aws_security_group.allow_all.name]
    tags = {
      Name = "Mongodb"
    }
}
resource "aws_instance" "ec2" {
    ami =  var.ec2_ami
    instance_type = "t2.micro"
}
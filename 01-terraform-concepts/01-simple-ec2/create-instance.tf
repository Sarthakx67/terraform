resource "aws_instance" "my-choice-name"{
    ami = var.image_id
    instance_type = var.instance_type
    security_groups = [aws_security_group.allow_all.name]
}
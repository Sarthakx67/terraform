resource "aws_instance" "conditions" {
    ami = "ami-0f918f7e67a3323f0"
    instance_type = var.instance-name == "mongodb" ?  "t3.medium" : "t2.micro"
}
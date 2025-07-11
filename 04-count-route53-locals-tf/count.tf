resource "aws_instance" "count_ec2" {
    count = 3
    ami = var.ec2_ami
    instance_type = var.instance_names[count.index] == "mongodb" || var.instance_names[count.index] == "mysql" ? "t2.micro" : "t2.micro"
    tags = {
        Name = var.instance_names[count.index]
    }
}
resource "aws_route53_record" "record" {
  count = 3
  zone_id = var.zone_id
  name    = "${var.instance_names[count.index]}.${var.domain}" #this is Interpolation
  type    = "A"
  ttl     = 1
  records = [aws_instance.count_ec2[count.index].private_ip]
}

resource "aws_key_pair" "deployer" {
  key_name   = "deployer-key"
  public_key =  local.key_public
}

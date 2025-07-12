resource "aws_instance" "for-loop" {
  for_each = var.instance_names #using for loop in our varibale "instance_names" to get key and value data of variable
  ami = var.ec2_ami
  instance_type = each.value

  tags = {
   name = each.key
  }
}

resource "aws_route53_record" "domain" {
  for_each = aws_instance.for-loop  #using for loop in our "for-loop" named file to get public and private ip
  zone_id = var.zone_id
  name    = "${each.key}.${var.domain}"
  type    = "A"
  ttl     = 1
  records = [ each.key == "web" ? each.value.public_ip : each.value.private_ip  ]
}


# output "aws_instance_info" {
#   value = aws_instance.for-loop
# }
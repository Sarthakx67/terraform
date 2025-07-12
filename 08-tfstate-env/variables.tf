variable "sg_name" {
  type = string
  # this will ask for input as default value and no other values are defined
}
variable "ec2_ami"{
    default = "ami-0f918f7e67a3323f0"
}
variable "ec2_region" {
    default = "ap-south-1"
}
variable "zone_id" {
    default = "Z0257382BYHW9PC3BT4M"
}
variable "domain" {
    default = "stallions.space"
}
variable "sg_cidr" {
    default = ["0.0.0.0/0"]
}
variable "instances" {
  type = map
  default = {
    MongoDB = "t2.micro"
    MySQL = "t2.micro"
    Redis = "t2.micro"
    # RabbitMQ = "t2.micro"
    # Catalogue = "t2.micro"
    # User = "t2.micro"
    # Cart = "t2.micro"
    # Shipping = "t2.micro"
    # Payment = "t2.micro"
    # Web = "t2.micro"
  }
}


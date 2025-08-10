variable "instances" {
  default = {
    # mongodb = "t2.micro"
    # mysql = "t2.micro"
    # redis = "t2.micro"
    # rabbitmq = "t2.micro"
    # user = "t2.micro"
    # cart = "t2.micro"
    catalogue = "t2.micro"
    # shipping = "t2.micro"
    # payment = "t2.micro"
    # web = "t2.micro"
    # ansible-server = "t2.micro" 
    # dispatch = "t2.micro"
  }
}
variable "zone_id" {
  default = "Z0257382BYHW9PC3BT4M"
}
variable "zone_name" {
  default = "stallions.space"
}
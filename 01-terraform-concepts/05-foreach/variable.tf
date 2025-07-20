variable "ec2_ami"{
    default = "ami-0f918f7e67a3323f0"
}
variable "ec2_region" {
    default = "ap-south-1"
}
variable "instance_names" {
    type = map
    default = {
        mongodb = "t2.micro"
        catalogue = "t2.micro"
        web = "t2.micro"
        cart = "t2.micro"
    }
}
variable "zone_id" {
    default = "Z0257382BYHW9PC3BT4M"
}
variable "domain" {
    default = "stallions.space"
}

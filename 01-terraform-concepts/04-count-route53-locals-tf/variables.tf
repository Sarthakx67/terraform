variable "ec2_ami"{
    default = "ami-0f918f7e67a3323f0"
}
variable "instance_type"{
    default = "t2.micro"
}
variable "ec2_region" {
    default = "ap-south-1"
}
variable "instance_names" {
    type = list
    default = ["mongodb", "redis", "mysql"]
}
variable "zone_id" {
    default = "Z0257382BYHW9PC3BT4M"
}
variable "domain" {
    default = "stallions.space"
}
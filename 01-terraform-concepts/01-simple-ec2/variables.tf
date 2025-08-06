variable "instance_type"{
    type = string
    default = "t2.micro"
}
variable "sg_name" {
    default = "allow-all"
}
variable "sg_cidr" {
    type = list
    default = ["0.0.0.0/0"]
}
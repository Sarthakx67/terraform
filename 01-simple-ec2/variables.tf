variable "image_id" {
    type = string
    default = "ami-0f918f7e67a3323f0"
}
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
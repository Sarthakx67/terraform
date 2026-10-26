variable "instance_type"{
    type = string
    default =    "t3.micro"   #"c7i-flex.large"  #"t3.micro"  #"m7i-flex.large"
}
variable "sg_name" {
    default = "allow-all"
}
variable "sg_cidr" {
    type = list
    default = ["0.0.0.0/0"]
}
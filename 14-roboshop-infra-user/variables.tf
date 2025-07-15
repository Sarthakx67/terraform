variable "cidr_block" {
    default = "10.0.0.0/16"
}
variable "common_tags" {
  default = {
    Project = "roboshop-vpc",
    Environment = "DEV"
    Terraform = true
  }
}
variable "project_name" {
  default = "roboshop"
}
variable "vpc_tags" {
    default = "roboshop-vpc"
}
variable "igw_tags" {
    default = "roboshop-igw"
}
variable "public_subnet_cidr_block" {
  default = ["10.0.1.0/24","10.0.2.0/24"]
}
variable "availability_zone" {
  default = ["ap-south-1a","ap-south-1b"]
}
variable "private_subnet_cidr_block" {
  default = ["10.0.11.0/24","10.0.12.0/24"]
}
variable "database_subnet_cidr_block" {
  default = ["10.0.21.0/24","10.0.22.0/24"]
}
variable "sg_name" {
  default = "allow-all"
}
variable "sg_description" {
  default = "allow-all"
}
variable "security_group_ingress_rule" {
  default = [
    {
      description = "allow-all"
      cidr_blocks = ["0.0.0.0/0"]
      from_port   = 0
      protocol    = "tcp"
      to_port     = 0
    },
    {
      description = "allow ssh"
      cidr_blocks = ["0.0.0.0/0"]
      from_port   = 22
      protocol    = "tcp"
      to_port     = 22
      }
  ]
}
variable "instances" {
  default = {
    MongoDB = "t2.micro"
    MySQL = "t2.micro"
    Redis = "t2.micro"
    RabbitMQ = "t2.micro"
    Catalogue = "t2.micro"
    User = "t2.micro"
    Cart = "t2.micro"
    Shipping = "t2.micro"
    Payment = "t2.micro"
    Web = "t2.micro"
  }
}
variable "zone_name" {
  default = "stallions.space"
}
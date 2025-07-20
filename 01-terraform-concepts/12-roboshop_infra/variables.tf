variable "cidr_block" {
  default = "10.0.0.0/16"
}
variable "common_tags" {
  default = {
   Project = "roboshop"
   Environment = "DEV"   # we are providing comman tags as map
   Terraform = "true"    # so we didnt have to change input value in main.tf for common_tags
  }
}
variable "vpc_tags" {
  default = {
   Name = "roboshop"
  }
}
variable "internet_gateway_tags" {
  default = {
    Name = "roboshop-igw"  
  }
}
variable "public_subnet_cidr" {
  default = ["10.0.1.0/24","10.0.2.0/24"]
}
variable "public_subnet_name" {
  default = ["roboshop-public-subnet-1","roboshop-public-subnet-2"] # we are providing as tuple/string so we have to change it as map in main.tf
}
variable "availability_zone" {
  default = ["ap-south-1a","ap-south-1b"]
}
variable "private_subnet_cidr" {
  default = ["10.0.11.0/24","10.0.12.0/24"]
}
variable "private_subnet_name" {
  default = ["roboshop-private-subnet-1","roboshop-private-subnet-2"]
}
variable "database_subnet_cidr" {
  default = ["10.0.21.0/24","10.0.22.0/24"]
}
variable "database_subnet_name" {
  default = ["database-private-subnet-1","database-private-subnet-2"]
}
variable "public_route_table_name" {
  default = {
    Name = "roboshop-public"
  }
}
variable "private_route_table_name" {
  default = {
    Name = "roboshop-private"
  }
}
variable "database_route_table_name" {
  default = {
    Name = "roboshop-database"
  }
}
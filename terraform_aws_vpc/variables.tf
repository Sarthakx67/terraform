# we will call these variables in tf files of roboshop infra

variable "cidr_block" {
    # default = "0.0.0.0/0"
}
variable "enable_dns_hostnames" {
  default = true
}
variable "enable_dns_support" {
  default = true
} 
variable "vpc_tags" {
  type = map
  default = {} # this means tags is optional
}
variable "common_tags" {
  default = {}
  type = map
}
variable "igw_tags" {
  default = {}
  type = map
}
variable "public_subnet_cidr" {
  
}
variable "azs" {
  
}
variable "public_subnet_name" {
  
}
variable "private_subnet_cidr" {
  
}
variable "private_subnet_name" {
  
}
variable "database_subnet_cidr" {
  
}
variable "database_subnet_name" {
  
}
variable "public_route_table_name" {

}
variable "private_route_table_name" {
  
}
variable "database_route_table_name" {
  
}
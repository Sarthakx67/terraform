module "this" {
  source = "../terraform_aws_vpc"
  # creating vpc
  cidr_block = var.cidr_block
  common_tags = var.common_tags
  vpc_tags = var.vpc_tags
  # creating internet gateways
  igw_tags = var.internet_gateway_tags
  # creating public subnet in 2 AZ's
  public_subnet_cidr = var.public_subnet_cidr 
  azs = var.availability_zone
  public_subnet_name = var.public_subnet_name
  # creating private subnet in 2 AZ's
  private_subnet_cidr = var.private_subnet_cidr
  private_subnet_name = var.private_subnet_name
  # creating database subnet in 2 AZ's
  database_subnet_cidr = var.database_subnet_cidr
  database_subnet_name = var.database_subnet_name
  # creating public route table
  public_route_table_name = var.public_route_table_name
  # creating private route table
  private_route_table_name = var.private_route_table_name
  # creating database route table
  database_route_table_name = var.database_route_table_name
}

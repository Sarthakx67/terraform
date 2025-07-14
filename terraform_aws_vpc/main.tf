resource "aws_vpc" "this" {
  cidr_block       = var.cidr_block
  enable_dns_hostnames = var.enable_dns_hostnames
  enable_dns_support = var.enable_dns_support

  tags = merge(
    var.common_tags,
    var.vpc_tags
  )
}
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.this.id

  tags = merge(
    var.common_tags,
    var.igw_tags
  )
}
resource "aws_subnet" "public_subnet" {           # loop HERE
  count = length(var.public_subnet_cidr) # 2 in this case as only 2 elements is present
  vpc_id     = aws_vpc.this.id
  cidr_block = var.public_subnet_cidr[count.index]
  availability_zone = var.azs[count.index]

  tags = merge(
    var.common_tags, #this is also a map
    {
        Name = var.public_subnet_name[count.index] #this is a map
    } # here we are providing public_subnet_name which is "tuple" as map 
  )
}
resource "aws_subnet" "private_subnet" {           # loop HERE
  count = length(var.private_subnet_cidr) # 2 in this case as only 2 elements is present
  vpc_id     = aws_vpc.this.id
  cidr_block = var.private_subnet_cidr[count.index]
  availability_zone = var.azs[count.index]

  tags = merge(
    var.common_tags, #this is also a map
    {
        Name = var.private_subnet_name[count.index] #this is a map
    }
  )
}
resource "aws_subnet" "database_subnet" {           # loop HERE
  count = length(var.database_subnet_cidr) # 2 in this case as only 2 elements is present
  vpc_id     = aws_vpc.this.id
  cidr_block = var.database_subnet_cidr[count.index]
  availability_zone = var.azs[count.index]

  tags = merge(
    var.common_tags, #this is also a map
    {
        Name = var.database_subnet_name[count.index] #this is a map
    }
  )
}
# 1. Create the Route Table
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.this.id

  tags = merge(
    var.common_tags,
    var.public_route_table_name
  )
}
# 2. Add Individual Routes (e.g., default route to IGW)
resource "aws_route" "public_internet_route" {
  route_table_id         = aws_route_table.public_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.gw.id
  depends_on = [ aws_route_table.public_rt ] # to tell terraform to create this resource first instead of creating current resource
}
# 3. Associate Subnets with this Route Table
# we will create 2 association --> 1st public-subnet-1
#                                  2nd public-subnet-2
resource "aws_route_table_association" "public_subnet_association" {
  count = length(var.public_subnet_cidr)
  subnet_id = element(aws_subnet.public_subnet[*].id, count.index)

#  fucntion --> element(aws_subnet.public_subnet[*].id, count.index)
#  above function will fetch list of subnets which are "public-subnet-1" and "public-subnet-2"
#  out of which "count.index" will select all list and perform action

  route_table_id = aws_route_table.public_rt.id
}
resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.this.id
  tags = merge(
    var.common_tags,
    var.private_route_table_name
  )
}
resource "aws_route_table_association" "private_subnet_association" {
  count = length(var.private_subnet_cidr)
  subnet_id = element(aws_subnet.private_subnet[*].id, count.index)
  route_table_id = aws_route_table.private_rt.id
}
resource "aws_route_table" "database_rt" {
  vpc_id = aws_vpc.this.id
  tags = merge(
    var.common_tags,
    var.database_route_table_name
  )
}
resource "aws_route_table_association" "database_subnet_association" {
  count = length(var.database_subnet_cidr)
  subnet_id = element(aws_subnet.database_subnet[*].id, count.index)
  route_table_id = aws_route_table.database_rt.id
}
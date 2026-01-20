resource "aws_vpc" "dynamic-website-vpc" {
  cidr_block       = "10.0.0.0/16"
  tags = {
    Name = "dynamic-website-vpc"
  }
}
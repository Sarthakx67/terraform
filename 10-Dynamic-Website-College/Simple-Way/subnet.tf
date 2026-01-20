resource "aws_subnet" "dynamic-website-subnet" {
  vpc_id     = aws_vpc.dynamic-website-vpc.id
  cidr_block = "10.0.1.0/24"
  map_public_ip_on_launch = true
  tags = {
    Name = "dynamic-website-subnet"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.dynamic-website-vpc.id
  tags   = { Name = "dynamic-website-igw" }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.dynamic-website-vpc.id
  tags   = { Name = "public-rt" }
}

resource "aws_route" "website_route" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

resource "aws_route_table_association" "public_assoc" {
  subnet_id      = aws_subnet.dynamic-website-subnet.id
  route_table_id = aws_route_table.public.id
}
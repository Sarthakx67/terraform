resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.project-vpc.id

  tags = {
    Name = "igw"
  }
}

resource "aws_subnet" "public-subnet" {
  vpc_id     = aws_vpc.project-vpc.id
  # For an EC2 instance to automatically receive a public IP address upon launch,
  # the subnet it's launched into must be configured to do so.
  # In Terraform, this is controlled by the map_public_ip_on_launch argument
  # within the aws_subnet resource. Its default value is false[1].
  map_public_ip_on_launch = true
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "public-subnet"
  }
}

resource "aws_subnet" "private-subnet" {
  vpc_id     = aws_vpc.project-vpc.id
  cidr_block = "10.0.2.0/24"

  tags = {
    Name = "private-subnet"
  }
}
resource "aws_route_table" "public-route-table" {
  vpc_id = aws_vpc.project-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "public-route-table"
  }
}

resource "aws_route_table_association" "associating-pub-subnet-with-public-route-table" {
  subnet_id      = aws_subnet.public-subnet.id
  route_table_id = aws_route_table.public-route-table.id
}

resource "aws_security_group" "allow_http_ssh" {
  name        = "allow_http"
  description = "Allow http inbound traffic, ssh from my laptop and all outbound traffic"
  vpc_id      = aws_vpc.project-vpc.id

  tags = {
    Name = "allow_http_ssh"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_http_ipv4" {
  security_group_id = aws_security_group.allow_http_ssh.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80

  tags = {
    Name = "allowing http"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_ssh" {
  security_group_id = aws_security_group.allow_http_ssh.id
  cidr_ipv4         = "106.219.145.13/32" # we give /32 as it is for host ip
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22

  tags = {
    Name = "allowing ssh only to my ip"
  }
}
resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.allow_http_ssh.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}


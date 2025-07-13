output "ec2" {
  value = aws_instance.ec2
}
output "public-subnet" {
    value = aws_subnet.public-subnet
}
output "route-table" {
    value = aws_route_table.public-route-table
}
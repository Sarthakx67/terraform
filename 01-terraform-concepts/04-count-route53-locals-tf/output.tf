output "private_ips" {
  value = aws_instance.count_ec2[*].private_ip
}
output "public_ip" {
  value = aws_instance.count_ec2[*].public_ip
}
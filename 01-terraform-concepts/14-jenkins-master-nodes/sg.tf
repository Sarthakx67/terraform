############################
# Security Group
############################
resource "aws_security_group" "allow_master" {
  name        = "allow_master"
  description = "Allow access to master node"
  vpc_id      = data.aws_vpc.default.id

  tags = {
    Name = "allow_master"
  }
}

############################
# Ingress: Allow All Ports From My IP
############################
resource "aws_security_group_rule" "vpn" {
  type              = "ingress"
  security_group_id = aws_security_group.allow_master.id

  cidr_blocks = ["${chomp(data.http.myip.response_body)}/32"]

  from_port = 0
  to_port   = 65535
  protocol  = "tcp"
}

############################
# Egress: Allow All Outbound Traffic
############################
resource "aws_security_group_rule" "allow_all_egress" {
  type              = "egress"
  security_group_id = aws_security_group.allow_master.id

  cidr_blocks = ["0.0.0.0/0"]

  from_port = 0
  to_port   = 0
  protocol  = "-1"
}
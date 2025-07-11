resource "aws_security_group" "allow_all" {
    name = var.sg_name 
    description = "Allow all inbound traffic and all outbound traffic"

    ingress{
        description = "allow all inbound traffic"
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = var.sg_cidr
    }
    egress{
        description = "allow all outbound traffic"
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = var.sg_cidr
    }
}



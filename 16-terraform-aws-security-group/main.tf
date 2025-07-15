resource "aws_security_group" "main" {
  name        = var.sg_name
  description = var.sg_description
  vpc_id      = var.vpc_id

  dynamic ingress {
    for_each = var.security_group_ingress_rule
    content {    
        description = ingress.value["description"]
        cidr_blocks = ingress.value.cidr_blocks
        from_port   = ingress.value.from_port
        protocol    = ingress.value.protocol
        to_port     = ingress.value.to_port
    }
  } 

  egress {
    cidr_blocks =  ["0.0.0.0/0"]
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
    }


  tags = merge(
    var.common_tags,
    {
        Name = "${var.project_name}-${var.sg_name}"
    },
    var.sg_tags
  )
}


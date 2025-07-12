variable "ingress" {
        default = [
            {
                from_port        = 80    
                to_port          = 80
                description = "allowing PORT 80 from public"
                protocol         = "tcp"
                cidr_blocks      = ["0.0.0.0/0"]
            },
            { 
                from_port        = 443
                to_port          = 443
                description = "allowing PORT 443 from public"
                protocol         = "tcp"
                cidr_blocks      = ["0.0.0.0/0"]
            },
            { 
                from_port        = 22
                to_port          = 22
                protocol         = "ssh"
                description = "allowing PORT 22 from public"
                cidr_blocks      = ["0.0.0.0/0"]
            }
        ]
}

variable "ec2_ami"{
    default = "ami-0f918f7e67a3323f0"
}
variable "ec2_region" {
    default = "ap-south-1"
}

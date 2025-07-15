# data "aws_ami" "roboshop-ami" {
#   most_recent      = true
#   name_regex       = "Ubuntu_22.04-x86_64-SQL_2022_Express-2024.05.30"
#   owners           = ["564516608959"]

#   filter {
#     name   = "name"
#     values = ["Ubuntu_22.04-x86_64-SQL_2022_Express-2024.05.30"]
#   }

#   filter {
#     name   = "root-device-type"
#     values = ["ebs"]
#   }

#   filter {
#     name   = "virtualization-type"
#     values = ["hvm"]
#   }
# }
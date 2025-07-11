# locals in terraform ast as variables but have special capabilities of
# storing and executing expressions and functions which will run at run time and provide the values

locals {
  key_public = file("${path.module}/DevOps.pub") // file module read file and give readed data
}
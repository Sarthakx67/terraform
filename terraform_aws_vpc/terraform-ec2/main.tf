module "ec2" {
  source = "../terraform-module"
  ec2_ami = "ami-0f918f7e67a3323f0" # we can give ami id according to ourself here  
  instance_type = "t2.micro" #provide instance type you want here
}
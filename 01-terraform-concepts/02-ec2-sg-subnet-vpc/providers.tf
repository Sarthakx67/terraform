terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = var.ec2_region
}

resource "aws_vpc" "ec2-tf-vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "ec2-tf-vpc"
  }
}

resource "aws_subnet" "Ec2-subnet-vpc-tf" {
  vpc_id     = aws_vpc.ec2-tf-vpc.id
  cidr_block = "10.0.0.0/24"
  availability_zone = "ap-south-1a"

  tags = {
    Name = "ec2-tf"
  }
}
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
  backend "s3" {
    bucket   = "sarthak-remote-tfstate"
    key = "sarthak-vpc"
    region = "ap-south-1"
    dynamodb_table = "sarthak-tfstate-lock"
  }
}

provider "aws" {
  region = "ap-south-1"
}
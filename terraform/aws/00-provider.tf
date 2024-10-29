terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.73.0"
    }
  }
  backend "s3" {
    bucket         = "staticsitelbpeeringtf"
    key            = "terraform.tfstate"
    dynamodb_table = "staticsitelbpeeringtf"
    region         = "us-east-1"
  }
}

provider "aws" {
  region = "us-east-1"
}
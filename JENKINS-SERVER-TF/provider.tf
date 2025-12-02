provider "aws" {
    region = "ap-south-1"
    
    }
    
terraform {
backend "s3" {
    bucket = "devsecops-s3-bucket843"
    key    = "devsecops-s3-bucket843/terraform.tfstate"
    region = "ap-south-1"
    encrypt = true
  }
}
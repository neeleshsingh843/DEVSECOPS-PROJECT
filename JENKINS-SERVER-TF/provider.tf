provider "aws" {
    region = "ap-south-1"
    
    }
    
terraform {
backend "s3" {
    bucket = data.aws_s3_bucket.s3bucket.bucket
    key    = "jenkins-server/terraform.tfstate"
    region = "ap-south-1"
    encrypt = true
  }
}
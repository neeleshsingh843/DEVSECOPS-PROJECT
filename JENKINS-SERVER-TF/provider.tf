provider "aws" {
    region = "ap-south-1"
    
    }
    
terraform {
backend "s3" {
    bucket = "jenkins-server-terraform-state"
    key    = "jenkins-server/terraform.tfstate"
    region = "ap-south-1"
    encrypt = true
    use_lockfile = true
  }
}
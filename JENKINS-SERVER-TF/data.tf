data "aws_ami" "AMI" {
    most_recent = true
    filter {
        name   = "name"
        values = ["amzn2-ami-hvm-*-x86_64-gp2"]
    }
    filter {
        name   = "virtualization-type"
        values = ["hvm"]
    }
    owners = ["137112412989"] # Amazon
  
}

data "aws_s3_bucket" "s3bucket" {
     bucket = "devsecops-s3-bucket843"  
}
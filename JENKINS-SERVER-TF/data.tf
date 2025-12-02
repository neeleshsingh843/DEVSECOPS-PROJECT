data "aws_ami" "AMI" {
    most_recent = true
    owners      = ["137112412989"] # Amazon

  filter {
    name   = "image-id"
    values = ["ami-0d176f79571d18a8f"]
  }

  
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}


variable "region" {
  description = "REGION"
  type = string
}
variable "env" {
  description = "SELECT THE ENVIRONMENT"
  type = string
}
variable "vpc_cidr" {
    description = "CIDR FOR VPC"
    type = string
    default = "10.0.0.0/16"
  
}
variable "pub-subnet-count" {
  description = "number of subnets"
  type = number
}
variable "pub_subnet_cidr" {
    description = "CIDR FOR SUBNET"
    type = list(string)
  
  
}

variable "pub-availability-zone" {
  type = list(string)
}

variable "ec2-instance-count" {
  description = "number of instances"
  type = number
  
}
variable "ec2_volume_size" {
  description = "Size of the EC2 root volume in GB"
  type = number
}
variable "ec2_volume_type" {
  description = "type of the volume"
  type = string
}

variable "ingress_ports" {
   description = "List of ports to allow inbound traffic"
   type = list(number)
   default = [22,443,80,8080,9000]   
}

variable "instance_type" {
  type = list(string)
  
}

variable "key-name" {
  type = string
  default = "pilot"
}
variable "vpc_cidr" {
    description = "CIDR FOR VPC"
    type = string
    default = "10.0.0.0/16"
  
}

variable "subnet_cidr" {
    description = "CIDR FOR SUBNET"
    type = string
    default = "10.0.1.0/24"
  
}

variable "ingress_ports"{
   description = "List of ports to allow inbound traffic"
   type = list(number)
   default = [22,443,80,8080,9000]   
}

variable "instance_type" {
  type = "string"
  default = "t2.micro"
}

variable "key-name" {
  type = "string"
  default = "pilot"
}
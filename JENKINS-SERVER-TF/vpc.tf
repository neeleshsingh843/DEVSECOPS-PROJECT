locals {
  org = "neelesh"
  project = "DEVSECOPS"
  env = var.env
}


#---------------- VPC CREATION -----------------
resource "aws_vpc" "VPC" {
    cidr_block =  var.vpc_cidr
    instance_tenancy = "default"
    enable_dns_hostnames = true
    enable_dns_support = true
    tags = {
        Name = "${local.org}-${local.project}-${local.env}-VPC"
        Env = "${local.env} "
    }
  
}
#---------------- INTERNET GATEWAY CREATION -----------------
resource "aws_internet_gateway" "IGW" {
    vpc_id = aws_vpc.VPC.id
    tags ={
        Name = "${local.org}-${local.project}-${local.env}-IGW"
        env = var.env
    }
    depends_on = [ aws_vpc.VPC ]
}
#---------------- SUBNET CREATION -----------------
resource "aws_subnet" "PUBLIC-SUBNET" {
    count =  var.pub-subnet-count
    vpc_id = aws_vpc.VPC.id
    cidr_block = element(var.pub_subnet_cidr, count.index)
    availability_zone = element(var.pub-availability-zone, count.index)
   tags = {
        Name = "${local.org}-${local.project}-${local.env}-PUBLIC-SUBNET-${count.index +1}"
        env = var.env
   }
   depends_on = [ aws_vpc.VPC ]
}
#---------------- ROUTE TABLE CREATION -----------------
resource "aws_route_table"  "RT" {
    vpc_id = aws_vpc.VPC.id
    route {
            cidr_block =  "0.0.0.0/0"  
            gateway_id = aws_internet_gateway.IGW.id
            }
    tags = {
        Name = "${local.org}-${local.project}-${local.env}-pub-RT"
        env = var.env
    }
   depends_on = [ aws_vpc.VPC ]
}
#---------------- ROUTE TABLE ASSOCIATION -----------------
resource "aws_route_table_association" "RTA" {
    count = 4
    subnet_id = aws_subnet.PUBLIC-SUBNET[count.index].id
    route_table_id = aws_route_table.RT.id
    depends_on = [ aws_vpc.VPC, aws_subnet.PUBLIC-SUBNET ]
}

#---------------- SECURITY GROUP CREATION -----------------
resource "aws_security_group" "SG" {
    vpc_id = aws_vpc.VPC.id
    name = "${local.org}-${local.project}-${local.env}-SG"
    dynamic "ingress"  {
        for_each = var.ingress_ports 
        content {
            description   = "Allow inbound traffic on port ${ingress.value} "
            from_port = ingress.value
            to_port   = ingress.value
            protocol  = "tcp"
            cidr_blocks = ["0.0.0.0/0"]
           
        }
    }
        egress {
            from_port   = 0
            to_port     = 0
            protocol    = "-1"
            cidr_blocks = ["0.0.0.0/0"]
        }
    tags = {
        Name = "${local.org}-${local.project}-${local.env}-SG"

    }

}
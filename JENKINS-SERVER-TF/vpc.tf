#---------------- VPC CREATION -----------------
resource "aws_vpc" "VPC" {
    cidr_block =  var.vpc_cidr
    tags = {
        Name = "DEVSECOPS-JEN-VPC"
    }
  
}
#---------------- INTERNET GATEWAY CREATION -----------------
resource "aws_internet_gateway" "IGW" {
    vpc_id = aws_vpc.VPC.id
    tags ={
        Name = "DEVSECOPS-IGW"
    }
}
#---------------- SUBNET CREATION -----------------
resource "aws_subnet" "SUBNET" {
    vpc_id = aws_vpc.VPC.id
    cidr_block = var.subnet_cidr
    availability_zone = "ap-south-1a"
   tags = {
        Name = "DEVSECOPS-SUBNET"
   }
}
#---------------- ROUTE TABLE CREATION -----------------
resource "aws_route_table"  "RT" {
    vpc_id = aws_vpc.VPC.id
    route {
            cidr_block =  "0.0.0.0/0"  
            gateway_id = aws_internet_gateway.IGW.id
            }
    tags = {
        Name = "DEVSECOPS-RT"
    }
  
}
#---------------- ROUTE TABLE ASSOCIATION -----------------
resource "aws_route_table_association" "RTA" {
    subnet_id = aws_subnet.SUBNET.id
    route_table_id = aws_route_table.RT.id
}

#---------------- SECURITY GROUP CREATION -----------------
resource "aws_security_group" "SG" {
    vpc_id = aws_vpc.VPC.id
    name = "DEVSECOPS-SG"
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
        Name = "DEVSECOPS-SG"

    }

}
#---------------- VPC CREATION -----------------
resource "aws_vpc" "VPC" {
    cidr_block =  "var.vpc_cidr"
    tags = {
        Name = "VPC"
    }
  
}
#---------------- INTERNET GATEWAY CREATION -----------------
resource "aws_internet_gateway" "IGW" {
    vpc_id = aws_vpc_id.VPC.id
    tags ={
        Name = "IGW"
    }
}
#---------------- SUBNET CREATION -----------------
resource "aws_subnet" "SUBNET" {
    vpc_id = aws_vpc.VPC.id
    cidr_block = "var.subnet_cidr"
    availability_zone = "ap-south-1a"
   tags = {
        Name = "SUBNET"
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
        Name = "RT"
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
    ingress = [
        for port in var.ingress_ports : {
            description   = "Allow inbound traffic on port ${port} "
            from_port = port
            to_port   = port
            protocol  = "tcp"
            cidr_blocks = ["0.0.0.0/0"]
        }]
        egress = {
            from_port   = 0
            to_port     = 0
            protocol    = "-1"
            cidr_blocks = ["0.0.0.0/0"]
}
    tags = {
        Name = "DEVSECOPS-SG"

    }

}
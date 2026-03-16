resource "aws_vpc" "my_vpc" {
  cidr_block = var.cidr_block  
  enable_dns_hostnames = true
  enable_dns_support = true
  tags = {
    Name = "my_vpc"
  }
}

resource "aws_subnet" "public_subnet" {
  vpc_id = aws_vpc.my_vpc.id 
  cidr_block = var.cidr_block_subnet_public
  availability_zone = var.az
  map_public_ip_on_launch = true

  tags = {
    Name = "public_subnet"
  }
}

resource "aws_internet_gateway" "my_igw" {
  vpc_id = aws_vpc.my_vpc.id 
  tags = {
    Name = "my_igw" 
  }  
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.my_vpc.id 
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.my_igw.id 
  }
    tags = {
        Name = "public_rt"
  }
}

resource "aws_route_table_association" "public_rt_ass" {
  subnet_id = aws_subnet.public_subnet.id 
  route_table_id = aws_route_table.public_rt.id   
}
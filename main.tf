terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "eu-central-1"
}

resource "aws_instance" "ec2_instance" {
  count = var.count_num
  ami = "ami-074dd8e8dac7651a5"
  instance_type = "t2.medium"
  key_name = "Gent-key-pair"
  subnet_id = aws_subnet.public_subnet.id 
  vpc_security_group_ids = [aws_security_group.instance_sg.id]
 
  tags = {
    Name = "Ec2Instance-${count.index +1}"
  }
}

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

resource "aws_security_group" "instance_sg" {
  name = "Instance-SG"
  description = "Security group for my EC2 Instances"

  vpc_id = aws_vpc.my_vpc.id 

  ingress {
    description = "Allow SSH from anywhere"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["195.158.86.220/32"]
  }

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1" # -1 means all protocols
    self        = true # This is the key: it refers to the security group itself
    description = "Allow all internal VPC traffic"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1" # -1 means all protocols
    cidr_blocks = ["0.0.0.0/0"]
    #ipv6_cidr_blocks = ["::/0"]
  }
  tags = {
    Name = "allow ssh from my ip on"
  }

}
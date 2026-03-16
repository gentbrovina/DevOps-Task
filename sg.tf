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
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
resource "aws_instance" "en_node" {
  ami           = "ami-01d87646ef267ccd7"
  instance_type = "t2.micro"
  subnet_id       = aws_subnet.my_subnet.id
  security_groups = [aws_security_group.en_sg.id]
  associate_public_ip_address = true
  key_name = "wemade_seoul"
  
    tags = {
    Name = "en_node"
  }

}

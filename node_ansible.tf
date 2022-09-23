resource "aws_instance" "ansible" {
  ami           = "ami-01d87646ef267ccd7"
  instance_type = "t2.micro"
  subnet_id       = aws_subnet.private_subnet.id
  security_groups = [aws_security_group.scn_sg.id]

  tags = {
    Name = "sc_node"
  }
}

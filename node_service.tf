resource "aws_instance" "sc_node" {
  ami           = "ami-01d87646ef267ccd7"
  instance_type = "t2.micro"
  subnet_id       = aws_subnet.private_subnet.id
  security_groups = [aws_security_group.scn_sg.id]

  tags = {
    Name = "sc_node"
  }
}

resource "aws_instance" "sc_node_2" {
  ami           = "ami-01d87646ef267ccd7"
  instance_type = "t2.micro"
  subnet_id       = aws_subnet.private_subnet.id
  security_groups = [aws_security_group.scn_sg.id]


  tags = {
    Name = "sc_node_2"
  }
}

resource "aws_instance" "sc_node_3" {
  ami           = "ami-01d87646ef267ccd7"
  instance_type = "t2.micro"
  subnet_id       = aws_subnet.private_subnet.id
  security_groups = [aws_security_group.scn_sg.id]


  tags = {
    Name = "sc_node_3"
  }
}

resource "aws_instance" "sc_node_4" {
  ami           = "ami-01d87646ef267ccd7"
  instance_type = "t2.micro"
  subnet_id       = aws_subnet.private_subnet.id
  security_groups = [aws_security_group.scn_sg.id]


  tags = {
    Name = "sc_node_4"
  }
}

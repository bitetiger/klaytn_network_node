resource "aws_instance" "sc_node" {
  ami           = "ami-01d87646ef267ccd7"
  instance_type = "t2.micro"
  subnet_id       = aws_subnet.sc_subnet.id
  security_groups = [aws_security_group.sc_sg.id]

  tags = {
    Name = "sc_node"
  }
}

resource "aws_instance" "sc_node_2" {
  ami           = "ami-01d87646ef267ccd7"
  instance_type = "t2.micro"
  subnet_id       = aws_subnet.sc_subnet.id
  security_groups = [aws_security_group.sc_sg.id]


  tags = {
    Name = "sc_node_2"
  }

}

resource "aws_subnet" "sc_subnet" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.4.0/24"
  availability_zone = "ap-northeast-2a"

  tags = {
    Name = "sc_subnet"
  }
}

resource "aws_security_group" "sc_sg" {
  name        = "sc_sg"
  vpc_id      = aws_vpc.main.id

  ingress {
    description      = "TLS from VPC"
    from_port        = 22
    to_port          = 22
    protocol         = "TCP"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "allow_tls"
  }
}
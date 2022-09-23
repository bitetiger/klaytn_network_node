resource "aws_instance" "en_node" {
  ami           = "ami-01d87646ef267ccd7"
  instance_type = "t2.micro"
  subnet_id       = aws_subnet.en_subnet.id
  security_groups = [aws_security_group.en_sg.id]

    tags = {
    Name = "en_node"
  }

  provisioner "remote-exec" {
    script = "./bootstrap.sh"
  }


}

resource "aws_subnet" "en_subnet" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.0.0/24"
  availability_zone = "ap-northeast-2a"

  tags = {
    Name = "en_subnet"
  }

}

resource "aws_security_group" "en_sg" {
  name        = "en_sg"
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
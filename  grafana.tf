resource "aws_instance" "grafana-ec2" {
  ami           = "ami-058165de3b7202099" # ap-northeast-2 Ubuntu 22.04 (LTS)
  instance_type = "t2.micro"
  subnet_id = aws_subnet.grafana_subnet.id
  key_name = aws_key_pair.kp.key_name

  associate_public_ip_address = true
  vpc_security_group_ids = [aws_security_group.allow_grafana.id]
  user_data = "${file("./scripts/grafana.sh")}"

  tags = {
    Name = "grafana-ec2"
  }
}

resource "aws_route_table" "route_grafana" {
  vpc_id = aws_vpc.my_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.my_vpc_gw.id
  }

  tags = {
    Name = "grafana"
  }
}

resource "aws_main_route_table_association" "a" {
  vpc_id         = aws_vpc.my_vpc.id
  route_table_id = aws_route_table.route_grafana.id
}

resource "aws_subnet" "grafana_subnet" {
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = "10.0.50.0/24"
  availability_zone = "ap-northeast-2a"
  map_public_ip_on_launch = true
  tags = {
    Name = "grafana"
  }
}

resource "aws_security_group" "allow_grafana" {
  name        = "Grafana-SecGp"
  description = "Allow inbound grafana traffic"
  vpc_id      = aws_vpc.my_vpc.id

  ingress {
    description      = "Grafana traffic (3000) from VPC"
    from_port        = 3000
    to_port          = 3000
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    description      = "SSH from VPC"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
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
    Name = "allow_grafana"
  }
}


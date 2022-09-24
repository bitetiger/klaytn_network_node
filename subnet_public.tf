resource "aws_internet_gateway" "my_vpc_gw" {
  vpc_id = aws_vpc.my_vpc.id

  tags = {
    Name = "public"
  }
}

resource "aws_route_table" "route_table" {
  vpc_id = aws_vpc.my_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.my_vpc_gw.id
  }

  tags = {
    Name = "public"
  }
}

resource "aws_route_table_association" "route_association" {
  subnet_id      = aws_subnet.my_subnet.id
  route_table_id = aws_route_table.route_table.id
}

resource "aws_subnet" "my_subnet" {
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = "10.0.5.0/24"
  availability_zone = "ap-northeast-2a"
  map_public_ip_on_launch = true
  tags = {
    Name = "public"
  }
}
resource "aws_security_group" "en_sg" {
  name        = "en_sg"
  vpc_id      = aws_vpc.my_vpc.id
  description = "SSH from Anywhere"

 ingress {
   description = "HTTP Access"
   from_port   = 80
   to_port     = 80
   protocol    = "tcp"
   cidr_blocks = ["0.0.0.0/0"]
 }

  ingress {
   description = "SSH Access"
   from_port   = 22323
   to_port     = 22323
   protocol    = "tcp"
   cidr_blocks = ["0.0.0.0/0"]
 }

   ingress {
   description = "SSH Access"
   from_port   = 22324
   to_port     = 22324
   protocol    = "tcp"
   cidr_blocks = ["0.0.0.0/0"]
 }
 
 ingress {
   description = "SSH Access"
   from_port   = 22
   to_port     = 22
   protocol    = "tcp"
   cidr_blocks = ["0.0.0.0/0"]
 }

  ingress {
   description = "endpoint Access"
   from_port   = 50505
   to_port     = 50505
   protocol    = "tcp"
   cidr_blocks = ["0.0.0.0/0"]
 }

 egress {
   from_port   = 0
   to_port     = 0
   protocol    = "-1"
   cidr_blocks = ["0.0.0.0/0"]
 }
 
 tags = {
   Name = "public"
 }

}
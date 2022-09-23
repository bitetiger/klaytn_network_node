resource "aws_eip" "nat_1" {
  vpc   = true

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_nat_gateway" "nat_gateway_1" {
  allocation_id = aws_eip.nat_1.id

  # Private subnet이 아니라 public subnet을 연결
  subnet_id = aws_subnet.my_subnet.id

  tags = {
    Name = "NAT-GW-1"
  }
}

resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.my_vpc.id

  tags = {
    Name = "private"
  }
}

resource "aws_subnet" "private_subnet" {
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = "172.16.10.0/24"
  availability_zone = "ap-northeast-3a"
  map_public_ip_on_launch = true
  tags = {
    Name = "private"
  }
}

resource "aws_main_route_table_association" "private_route_association" {
  subnet_id      = aws_subnet.private_subnet.id
  route_table_id = aws_route_table.private_route_table.id
}

resource "aws_route" "private_nat_1" {
  route_table_id              = aws_route_table.private_route_table.id
  destination_cidr_block      = "0.0.0.0/0"
  nat_gateway_id              = aws_nat_gateway.nat_gateway_1.id
}

resource "aws_security_group" "scn_sg" {
  name        = "scn_sg"
  vpc_id      = aws_vpc.my_vpc.id
  description = "SSH from Anywhere"

 ingress {
   description = "HTTP Access"
   from_port   = 22323
   to_port     = 22323
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
 
 egress {
   from_port   = 0
   to_port     = 0
   protocol    = "-1"
   cidr_blocks = ["0.0.0.0/0"]
 }
 
 tags = {
   Name = "private"
 }

}
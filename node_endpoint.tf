resource "aws_instance" "en_node" {
  ami           = "ami-0d96fabb69923e576"
  instance_type = "t2.micro"
  subnet_id       = aws_subnet.my_subnet.id
  security_groups = [aws_security_group.en_sg.id]
  associate_public_ip_address = true
  key_name = "wemade_seoul"

    tags = {
    Name = "en_node"
  }
}

resource "aws_ebs_volume" "ebs_volume" {
  availability_zone = aws_instance.en_node.availability_zone
  size = 50
  tags = {
    Name = "endpoint_ebs"
  }
}
resource "aws_volume_attachment" "ebs_att" {
  device_name = "/dev/sdd"
  volume_id = aws_ebs_volume.ebs_volume.id
  instance_id = aws_instance.en_node.id
  force_detach = true
} 
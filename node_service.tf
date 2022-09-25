# Enpoint와 연결되는 Master SCN 
resource "aws_instance" "scn-master" {
  ami           = "ami-058165de3b7202099"
  instance_type = "t2.large"
  subnet_id       = aws_subnet.private_subnet.id
  security_groups = [aws_security_group.private_sg.id]
  associate_public_ip_address = true
  key_name = aws_key_pair.kp.key_name
  user_data = "${file("./scripts/scn_master.sh")}"

  tags = {
    Name = "scn-master"
  }
}

# 일반 SCN 노드
resource "aws_instance" "sc_node" {
  ami           = "ami-058165de3b7202099"
  instance_type = "t2.large"
  subnet_id       = aws_subnet.private_subnet.id
  security_groups = [aws_security_group.private_sg.id]
  associate_public_ip_address = true
  key_name = aws_key_pair.kp.key_name
  count    = 3
  user_data = "${file("./scripts/scn.sh")}"

  tags = {
    Name = "scn-${count.index + 1}"
  }
}

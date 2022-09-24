# Enpoint와 연결되는 Master SCN 
resource "aws_instance" "scn-master" {
  ami           = "ami-058165de3b7202099"
  instance_type = "t2.medium"
  subnet_id       = aws_subnet.my_subnet.id
  security_groups = [aws_security_group.en_sg.id]
  associate_public_ip_address = true
  key_name = aws_key_pair.kp.key_name
 
  connection {
        user = "ubuntu"
        private_key = file("./${aws_key_pair.kp.key_name}.pem")
        host = self.public_ip
        }

  provisioner "file" {
    source      = "./${aws_key_pair.kp.key_name}.pem"
    destination = "/home/ubuntu/${aws_key_pair.kp.key_name}.pem"
       }

    provisioner "remote-exec" {
        inline = [
            "cd /home/ubuntu",
            "wget https://packages.klaytn.net/klaytn/v1.9.0/kscn-v1.9.0-0-linux-amd64.tar.gz",
            "tar xvf kscn-v1.9.0-0-linux-amd64.tar.gz",
            "export PATH=$PATH:~/kscn-v1.9.0-0-linux-amd64/bin",
            "wget https://packages.klaytn.net/klaytn/v1.9.0/homi-v1.9.0-0-linux-amd64.tar.gz",
            "tar xvf homi-v1.9.0-0-linux-amd64.tar.gz",
            "cd homi-linux-amd64/bin/",
            "./homi setup local --cn-num 4 --test-num 1 --servicechain --chainID 1002 --p2p-port 22323 -o homi-output"
            ]
        } 

  tags = {
    Name = "scn-master"
  }
}

resource "aws_eip" "scn_master" {
  vpc   = true
  tags = {
    Name = "scn-master"
  }
}

resource "aws_eip_association" "scn_master" {
  instance_id   = aws_instance.scn-master.id
  allocation_id = aws_eip.scn_master.id
}

# 일반 SCN 노드
resource "aws_instance" "sc_node" {
  ami           = "ami-058165de3b7202099"
  instance_type = "t2.medium"
  subnet_id       = aws_subnet.my_subnet.id
  security_groups = [aws_security_group.en_sg.id]
  associate_public_ip_address = true
  key_name = aws_key_pair.kp.key_name
  count    = 3
 
  connection {
        user = "ubuntu"
        private_key = file("./${aws_key_pair.kp.key_name}.pem")
        host = self.public_ip
        }

    provisioner "remote-exec" {
        inline = [
            "cd ~",
            "wget https://packages.klaytn.net/klaytn/v1.9.0/kscn-v1.9.0-0-linux-amd64.tar.gz",
            "tar xvf kscn-v1.9.0-0-linux-amd64.tar.gz",
            "export PATH=$PATH:~/kscn-v1.9.0-0-linux-amd64/bin",
            ]
        } 

  tags = {
    Name = "scn-${count.index + 1}"
  }
}

resource "aws_eip" "scn" {
  count = 3
  vpc   = true
  tags = {
    Name = "scn-${count.index + 1}"
  }
}

resource "aws_eip_association" "scn" {
  count         = 3
  instance_id   = aws_instance.sc_node[count.index].id
  allocation_id = aws_eip.scn[count.index].id
}
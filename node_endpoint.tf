resource "aws_instance" "en_node" {
  ami           = "ami-058165de3b7202099"
  instance_type = "t2.large"
  subnet_id       = aws_subnet.my_subnet.id
  security_groups = [aws_security_group.en_sg.id]
  associate_public_ip_address = true
  key_name = aws_key_pair.kp.key_name

    tags = {
    Name = "en_node"
  }

  root_block_device {
    volume_size = 200
    volume_type = "gp2"
  }

  connection {
        user = "ubuntu"
        private_key = file("./${aws_key_pair.kp.key_name}.pem")
        host = self.public_ip
        }

  provisioner "file" {
    source      = "./${aws_key_pair.kp.key_name}.pem"
    destination = "/home/ubuntu/${aws_key_pair.kp.key_name}.pem"
       }

  provisioner "file" {
    source      = "./src/inventory_aws_ec2.yml"
    destination = "/home/ubuntu/inventory_aws_ec2.yml"
       }

  provisioner "file" {
    source      = "./src/ansible.cfg"
    destination = "/home/ubuntu/ansible.cfg"
       }

  provisioner "file" {
    source      = "./src/ping_playbook.yml"
    destination = "/home/ubuntu/ping_playbook.yml"
       }

    provisioner "remote-exec" {
        inline = [
            "cd /home/ubuntu",
            "sudo scp -r -o StrictHostKeyChecking=no -i ${aws_key_pair.kp.key_name} ${aws_key_pair.kp.key_name} ubuntu@${aws_instance.ansible.public_dns}:~/",
            "sudo scp -r -o StrictHostKeyChecking=no -i ${aws_key_pair.kp.key_name} ${aws_key_pair.kp.key_name} ubuntu@${aws_instance.scn-master.public_dns}:~/",
            "sudo scp -r -o StrictHostKeyChecking=no -i ${aws_key_pair.kp.key_name} inventory_aws_ec2.yml ubuntu@${aws_instance.ansible.public_dns}:~/",
            "sudo scp -r -o StrictHostKeyChecking=no -i ${aws_key_pair.kp.key_name} ping_playbook.yml ubuntu@${aws_instance.ansible.public_dns}:~/",
            "sudo scp -r -o StrictHostKeyChecking=no -i ${aws_key_pair.kp.key_name} ansible.cfg ubuntu@${aws_instance.ansible.public_dns}:~/",
            "wget https://packages.klaytn.net/klaytn/v1.9.0/ken-baobab-v1.9.0-0-linux-amd64.tar.gz",
            "tar xvf ken-baobab-v1.9.0-0-linux-amd64.tar.gz",
            "curl -X GET https://packages.klaytn.net/baobab/genesis.json -o ~/genesis.json",
            "export PATH=$PATH:/home/ubuntu/ken-linux-amd64/bin/",
            "ken --datadir ~/data init ~/genesis.json"
            ]
        }
}

resource "aws_ebs_volume" "ebs_volume" {
  availability_zone = aws_instance.en_node.availability_zone
  size = 100
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
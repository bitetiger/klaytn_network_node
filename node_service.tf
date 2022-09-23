resource "aws_instance" "sc_node_1" {
  ami           = "ami-01d87646ef267ccd7"
  instance_type = "t2.micro"
  subnet_id       = aws_subnet.my_subnet.id
  security_groups = [aws_security_group.en_sg.id]
  associate_public_ip_address = true
  key_name = "wemade_seoul"

    connection {
        user = "ec2-user"
        private_key = file("~/${aws_instance.sc_node_1.key_name}.pem")
        host = self.public_ip
        }

    provisioner "remote-exec" {
        /* script = "./scripts/scn1_script.sh" */
        inline = [
            "echo '[\"kni://e8075b09d3712458040067aaf8f306fc863c2d5e67baf8083f18438e2c4d1b9ee02e3b43b305bd6261e918e94c723b1777b3b89df0c729372cf863833327b5e8@${aws_instance.en_node.public_dns}:50505?discport=0\"]' > ~/main-bridges.json",
            "echo '[\"kni://9a9d4f504fa20c951068e2bab5ffb6e5bcf09c523efd4b0b4073423a88105dc46abb941a28a4699459faf8bad852ca02866fa26234d5fe57b33c923e074aab48@${aws_instance.sc_node_1.public_dns}:22323?discport=0\u0026ntype=cn\",\"kni://ef212b34db217c53893e56d816591ab9014ff7c1f3e6cb9a1312bfe3f6ae6631c1674368f6e7e7369ac0307c06d30cf35c9e092dabaa98912c7dccb5fd6fb556@${aws_instance.sc_node_2.public_dns}:22323?discport=0\u0026ntype=cn\",\"kni://ea7edf28dff063cf24129a51a75641154687c76a2f1abace3c6bf9be70a88ad189bfef8c036bcf8c1105fe99b88683c9fa1cafc8bb4cbf80d1c04ae48b633446@${aws_instance.sc_node_3.public_dns}:22323?discport=0\u0026ntype=cn\",\"kni://09e18bf7f4b20dd5e3125f7caa2520b89b8ec02462058a224196784997e961f16accaf149c458707d5963fc92db8f42da42873b81784d415f9aef2f64e6d1bfa@${aws_instance.sc_node_4.public_dns}:22323?discport=0\u0026ntype=cn\"]' > ~/data/static-nodes.json",
            "scp -r ~/data/static-nodes.json ec2-user@${aws_instance.sc_node_2.public_dns}:~/data/",
            "scp -r ~/data/static-nodes.json ec2-user@${aws_instance.sc_node_3.public_dns}:~/data/",
            "scp -r ~/data/static-nodes.json ec2-user@${aws_instance.sc_node_4.public_dns}:~/data/"
        ]
        }

  tags = {
    Name = "sc_node_1"
  }
}

resource "aws_instance" "sc_node_2" {
  ami           = "ami-01d87646ef267ccd7"
  instance_type = "t2.micro"
  subnet_id       = aws_subnet.my_subnet.id
  security_groups = [aws_security_group.en_sg.id]


  tags = {
    Name = "sc_node_2"
  }
}

resource "aws_instance" "sc_node_3" {
  ami           = "ami-01d87646ef267ccd7"
  instance_type = "t2.micro"
  subnet_id       = aws_subnet.my_subnet.id
  security_groups = [aws_security_group.en_sg.id]


  tags = {
    Name = "sc_node_3"
  }
}

resource "aws_instance" "sc_node_4" {
  ami           = "ami-01d87646ef267ccd7"
  instance_type = "t2.micro"
  subnet_id       = aws_subnet.my_subnet.id
  security_groups = [aws_security_group.en_sg.id]


  tags = {
    Name = "sc_node_4"
  }
}

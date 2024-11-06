resource "aws_security_group" "sg1" {
  name   = "sg1"
  vpc_id = data.aws_vpc.default.id
}

resource "aws_vpc_security_group_ingress_rule" "allow_ssh" {
  security_group_id = aws_security_group.sg1.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "tcp"
  from_port         = 22
  to_port           = 22
}

resource "aws_vpc_security_group_ingress_rule" "allow_jenkins" {
  security_group_id = aws_security_group.sg1.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "tcp"
  from_port         = 8080
  to_port           = 8080
}

resource "aws_vpc_security_group_egress_rule" "allow_all_egress" {
  security_group_id = aws_security_group.sg1.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}

resource "aws_key_pair" "default" {
  key_name   = "my-key"
  public_key = file("/Users/luiz_celeghin/.ssh/id_rsa.pub")
}

resource "aws_instance" "jenkins-server" {
  ami                    = var.ami_id_aws
  instance_type          = var.instance_type
  key_name               = aws_key_pair.default.key_name
  vpc_security_group_ids = [aws_security_group.sg1.id]

  tags = {
    Name = "jenkins-server"
  }
}

resource "ansible_host" "jenkins-server" {
  name   = "jenkins-server"
  groups = ["devops_tools"]

  variables = {
    ansible_user = "ec2-user"
    ansible_host = aws_instance.jenkins-server.public_ip
  }
}

resource "aws_instance" "ansible-server" {
  ami                    = var.ami_id_aws
  instance_type          = var.instance_type
  key_name               = aws_key_pair.default.key_name
  vpc_security_group_ids = [aws_security_group.sg1.id]

  tags = {
    Name = "ansible-server"
  }
}

resource "ansible_host" "ansible-server" {
  name   = "ansible-server"
  groups = ["devops_tools"]

  variables = {
    ansible_user = "ec2-user"
    ansible_host = aws_instance.ansible-server.public_ip
  }
}

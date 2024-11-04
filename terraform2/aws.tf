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
  ip_protocol       = "-1" # Egress for all ports
}

resource "aws_key_pair" "default" {
  key_name   = "my-key"
  public_key = file("/Users/luiz_celeghin/.ssh/id_rsa.pub")
}

resource "aws_instance" "jenkins-server" {
  # Amazon Linux on Public Subnet
  ami                    = var.ami_id_aws
  instance_type          = var.instance_type
  key_name               = aws_key_pair.default.key_name
  vpc_security_group_ids = [aws_security_group.sg1.id]
  # subnet_id              = aws_subnet.useast1_public[0].id

  tags = {
    Name = "jenkins-server"
  }
}

resource "ansible_host" "jenkins-server" {
  name   = "jenkins-server"
  groups = ["devops_tools"]

  variables = {
    # Connection vars.
    # Depends on the OS 
    # admin for Debian
    # ubuntu for Ubuntu
    # ec2-user for Amazon Linux
    ansible_user = "ec2-user"
    ansible_host = aws_instance.jenkins-server.public_ip

    # Custom vars.
    hostname = "jenkins-server"
    # fqdn     = "nginx.example.com"

    # To define lists or maps use jsonencode().
    packages = jsonencode(["nginx", ])

  }
}
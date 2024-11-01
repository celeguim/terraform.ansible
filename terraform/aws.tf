resource "aws_security_group" "allow_ssh" {
  name        = "allow_ssh"
  description = "Allow SSH inbound traffic and all outbound traffic"
  vpc_id      = data.aws_vpc.default.id
}

resource "aws_vpc_security_group_ingress_rule" "allow_ssh_ipv4" {
  security_group_id = aws_security_group.allow_ssh.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "tcp"
  from_port         = 22
  to_port           = 22
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.allow_ssh.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # All ports.
}

resource "aws_key_pair" "default" {
  key_name   = "terraform-example-key"
  public_key = file("/Users/luiz_celeghin/.ssh/id_rsa.pub")
}

resource "aws_instance" "web1" {
  # Ubuntu 22.04
  ami                    = "ami-0866a3c8686eaeeba"
  instance_type          = "t2.micro"
  key_name               = aws_key_pair.default.key_name
  vpc_security_group_ids = [aws_security_group.allow_ssh.id]

  tags = {
    Name = "web1"
  }
}

resource "aws_instance" "web2" {
  # Amazon Linux
  ami                    = "ami-06b21ccaeff8cd686"
  instance_type          = "t2.micro"
  key_name               = aws_key_pair.default.key_name
  vpc_security_group_ids = [aws_security_group.allow_ssh.id]

  tags = {
    Name = "web2"
  }
}

resource "ansible_host" "web1" {
  name   = "web1"
  groups = ["aws_web"]

  variables = {
    # Connection vars.
    ansible_user = "ubuntu" # Depends on the OS (admin for Debian).
    ansible_host = aws_instance.web1.public_ip

    # Custom vars.
    hostname = "web1"
    fqdn     = "web1.example.com"

    # To define lists or maps use jsonencode().
    packages = jsonencode(["openjdk-11-jre", "tomcat10", "tomcat10-admin"])

    map_var = jsonencode({
      provider = "AWS"
      region   = "us-east-1"
    })
  }
}

resource "ansible_host" "web2" {
  name   = "web2"
  groups = ["aws_web"]

  variables = {
    # Connection vars.
    ansible_user = "ec2-user" # Depends on the OS (admin for Debian).
    ansible_host = aws_instance.web2.public_ip

    # Custom vars.
    hostname = "web2"
    fqdn     = "web2.example.com"

    # To define lists or maps use jsonencode().
    packages = jsonencode(["nginx", "nginx-mod-devel"])

    map_var = jsonencode({
      provider = "AWS"
      region   = "us-east-1"
    })
  }
}

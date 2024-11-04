resource "aws_security_group" "sg1" {
  name   = "sg1"
  vpc_id = aws_vpc.useast1.id
}

resource "aws_vpc_security_group_ingress_rule" "allow_ssh_ipv4" {
  security_group_id = aws_security_group.sg1.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "tcp"
  from_port         = 22
  to_port           = 22
}

resource "aws_vpc_security_group_ingress_rule" "allow_http_ipv4" {
  security_group_id = aws_security_group.sg1.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "tcp"
  from_port         = 80
  to_port           = 80
}

resource "aws_vpc_security_group_ingress_rule" "allow_tomcat_ipv4" {
  security_group_id = aws_security_group.sg1.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "tcp"
  from_port         = 8080
  to_port           = 8080
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.sg1.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # Egress for all ports
}

resource "aws_key_pair" "default" {
  key_name   = "my-key"
  public_key = file("/Users/luiz_celeghin/.ssh/id_rsa.pub")
}

resource "aws_instance" "nginx" {
  # Amazon Linux on Public Subnet
  ami                    = var.ami_id_aws
  instance_type          = var.instance_type
  key_name               = aws_key_pair.default.key_name
  vpc_security_group_ids = [aws_security_group.sg1.id]
  subnet_id              = aws_subnet.useast1_public[0].id

  tags = {
    Name = "nginx-server"
  }
}

resource "aws_instance" "tomcat" {
  # Ubuntu 22.04 on Private Subnet
  ami                    = var.ami_id_ubuntu
  instance_type          = var.instance_type
  key_name               = aws_key_pair.default.key_name
  vpc_security_group_ids = [aws_security_group.sg1.id]
  subnet_id              = aws_subnet.useast1_private[0].id

  tags = {
    Name = "tomcat-server"
  }
}

resource "ansible_host" "nginx" {
  name   = "nginx"
  groups = ["aws_web"]

  variables = {
    # Connection vars.
    # Depends on the OS 
    # admin for Debian
    # ubuntu for Ubuntu
    # ec2-user for Amazon Linux
    ansible_user = "ec2-user"
    ansible_host = aws_instance.nginx.public_ip

    # Custom vars.
    hostname = "nginx"
    fqdn     = "nginx.example.com"

    # To define lists or maps use jsonencode().
    packages = jsonencode(["nginx", ])

    map_var = jsonencode({
      provider    = "AWS",
      server_type = "Web Server"
      region      = "us-east-1"
    })
  }
}

resource "ansible_host" "tomcat" {
  name   = "tomcat"
  groups = ["aws_web"]

  variables = {
    # Connection vars.
    # Connection vars.
    # Depends on the OS 
    # admin for Debian
    # ubuntu for Ubuntu
    # ec2-user for Amazon Linux
    ansible_user            = "ubuntu"
    ansible_host            = aws_instance.tomcat.private_ip
    ansible_ssh_common_args = "-o ProxyCommand='ssh -p 22 -W %h:%p -i ~/.ssh/id_rsa ec2-user@${aws_instance.nginx.public_ip}'"

    # Custom vars.
    hostname = "tomcat"
    fqdn     = "tomcat.example.com"

    # To define lists or maps use jsonencode().
    packages = jsonencode(["openjdk-17-jdk", "tomcat10", "tomcat10-examples"])

    map_var = jsonencode({
      provider    = "AWS",
      server_type = "Java Application Server"
      region      = "us-east-1"
    })
  }
}

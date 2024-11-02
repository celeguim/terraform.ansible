resource "aws_vpc" "useast1" {
  provider   = aws.useast1
  cidr_block = var.vpc_cidr["useast1"]
  tags = {
    Name = "vpc1"
  }
}

resource "aws_subnet" "useast1_public" {
  provider                = aws.useast1
  count                   = 2
  vpc_id                  = aws_vpc.useast1.id
  cidr_block              = element(var.public_subnet_cidrs["useast1"], count.index)
  map_public_ip_on_launch = true
  tags = {
    Name = "vpc1-public-${count.index}"
  }
}

resource "aws_subnet" "useast1_private" {
  provider                = aws.useast1
  count                   = 2
  vpc_id                  = aws_vpc.useast1.id
  cidr_block              = element(var.private_subnet_cidrs["useast1"], count.index)
  map_public_ip_on_launch = false
  tags = {
    Name = "vpc1-private-${count.index}"
  }
}

# internet gateway for vpc1
resource "aws_internet_gateway" "gw1" {
  provider = aws.useast1
  vpc_id   = aws_vpc.useast1.id
  tags = {
    Name = "gw1"
  }
}

# route table for gw1
resource "aws_route_table" "gw1_route_table" {
  vpc_id = aws_vpc.useast1.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw1.id
  }
  tags = {
    Name = "gw1_route_table"
  }
}

# route table for nat1
resource "aws_route_table" "nat1_route_table" {
  vpc_id = aws_vpc.useast1.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat1.id
  }
  tags = {
    Name = "nat1_route_table"
  }
}

# Associate GW1 Route Table to Public Subnet
resource "aws_route_table_association" "gw1_rt_association" {
  subnet_id      = aws_subnet.useast1_public[0].id
  route_table_id = aws_route_table.gw1_route_table.id
}

# Associate NAT1 Route Table to Public Subnet
resource "aws_route_table_association" "nat1_rt_association" {
  subnet_id      = aws_subnet.useast1_private[0].id
  route_table_id = aws_route_table.nat1_route_table.id
}

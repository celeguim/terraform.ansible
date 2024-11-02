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
    Name = "useast1_public"
  }
}

resource "aws_subnet" "useast1_private" {
  provider                = aws.useast1
  count                   = 2
  vpc_id                  = aws_vpc.useast1.id
  cidr_block              = element(var.private_subnet_cidrs["useast1"], count.index)
  map_public_ip_on_launch = false
  tags = {
    Name = "useast1_private"
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
resource "aws_route_table" "vpc1_route_table" {
  vpc_id = aws_vpc.useast1.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw1.id
  }
}

# Associate Route Table to Public Subnet
resource "aws_route_table_association" "public_association" {
  subnet_id      = aws_subnet.useast1_public[0].id
  route_table_id = aws_route_table.vpc1_route_table.id
}

resource "aws_vpc" "useast1" {
  provider   = aws.useast1
  cidr_block = var.vpc_cidr["useast1"]
}

resource "aws_subnet" "useast1_public" {
  provider                = aws.useast1
  count                   = 2
  vpc_id                  = aws_vpc.useast1.id
  cidr_block              = element(var.public_subnet_cidrs["useast1"], count.index)
  map_public_ip_on_launch = true
}

resource "aws_subnet" "useast1_private" {
  provider                = aws.useast1
  count                   = 2
  vpc_id                  = aws_vpc.useast1.id
  cidr_block              = element(var.private_subnet_cidrs["useast1"], count.index)
  map_public_ip_on_launch = false
}

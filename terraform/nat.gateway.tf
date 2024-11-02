resource "aws_eip" "nat" {
  provider = aws.useast1
}

resource "aws_nat_gateway" "nat" {
  provider      = aws.useast1
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.useast1_public[0].id
  tags = {
    Name = "NAT-Gateway"
  }
}

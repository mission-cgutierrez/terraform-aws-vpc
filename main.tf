resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr_block
  tags = {
    Name = "${var.name}-vpc"
  }
  enable_dns_hostnames = true
}

resource "aws_subnet" "private_subnet" {
  count             = length(var.private_subnets)
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnets[count.index].cidr_block
  availability_zone = var.private_subnets[count.index].availability_zone
  tags = {
    Name = "${var.name}-vpc-private-subnet-${var.private_subnets[count.index].availability_zone}"
  }
}

resource "aws_subnet" "public_subnet" {
  count             = length(var.public_subnets)
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.public_subnets[count.index].cidr_block
  availability_zone = var.public_subnets[count.index].availability_zone
  tags = {
    Name = "${var.name}-vpc-public-subnet-${var.public_subnets[count.index].availability_zone}"
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "${var.name}-vpc-igw"
  }
}

resource "aws_route_table" "private_route_table" {
  count  = length(var.private_subnets)
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "${var.name}-vpc-private-subnet-route-table-${var.private_subnets[count.index].availability_zone}"
  }
}

resource "aws_route_table" "public_route_table" {
  count  = length(var.public_subnets)
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "${var.name}-vpc-public-subnet-route-table-${var.public_subnets[count.index].availability_zone}"
  }
}

resource "aws_route" "private_route" {
  count                  = length(var.private_subnets)
  route_table_id         = aws_route_table.private_route_table[count.index].id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat_gw[count.index].id
}

resource "aws_route" "public_route" {
  count                  = length(var.public_subnets)
  route_table_id         = aws_route_table.public_route_table[count.index].id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.gw.id
}

resource "aws_eip" "nat_eip" {
  count  = length(var.private_subnets)
  domain = "vpc"
  tags = {
    Name = "${var.name}-vpc-${var.private_subnets[count.index].availability_zone}-nat"
  }
}

resource "aws_nat_gateway" "nat_gw" {
  count         = length(var.private_subnets)
  subnet_id     = aws_subnet.public_subnet[count.index].id
  allocation_id = aws_eip.nat_eip[count.index].id
  tags = {
    Name = "${var.name}-vpc-nat-gateway-${var.private_subnets[count.index].availability_zone}"
  }
}

resource "aws_route_table_association" "private_association" {
  count          = length(var.private_subnets)
  subnet_id      = aws_subnet.private_subnet[count.index].id
  route_table_id = aws_route_table.private_route_table[count.index].id
}

resource "aws_route_table_association" "public_association" {
  count          = length(var.public_subnets)
  subnet_id      = aws_subnet.public_subnet[count.index].id
  route_table_id = aws_route_table.public_route_table[count.index].id
}

resource "aws_vpc_endpoint" "dynamodb_endpoint" {
  vpc_id            = aws_vpc.main.id
  service_name      = "com.amazonaws.${var.region}.dynamodb"
  vpc_endpoint_type = "Gateway"
  route_table_ids   = aws_route_table.private_route_table[*].id
  tags = {
    Name = "${var.name}-vpc-dynamodb-endpoint"
  }
}

resource "aws_vpc_endpoint" "s3_endpoint" {
  vpc_id            = aws_vpc.main.id
  service_name      = "com.amazonaws.${var.region}.s3"
  vpc_endpoint_type = "Gateway"
  route_table_ids   = aws_route_table.private_route_table[*].id
  tags = {
    Name = "${var.name}-vpc-s3-endpoint"
  }
}

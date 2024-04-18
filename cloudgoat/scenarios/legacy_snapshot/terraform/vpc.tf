# vpc.tf
resource "aws_vpc" "cg_vpc" {
  cidr_block           = "10.10.0.0/16"
  enable_dns_hostnames = true

  tags = {
    Name = "CloudGoat VPC"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "cg_internet_gateway" {
  vpc_id = aws_vpc.cg_vpc.id

  tags = {
    Name = "CloudGoat Internet Gateway"
  }
}

# Public Subnets
resource "aws_subnet" "cg_public_subnet_1" {
  availability_zone = "${var.region}a"
  cidr_block        = "10.10.10.0/24"
  vpc_id            = aws_vpc.cg_vpc.id

  tags = {
    Name = "CloudGoat Public Subnet #1"
  }
}

resource "aws_subnet" "cg_public_subnet_2" {
  availability_zone = "${var.region}b"
  cidr_block        = "10.10.20.0/24"
  vpc_id            = aws_vpc.cg_vpc.id

  tags = {
    Name = "CloudGoat Public Subnet #2"
  }
}

resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.cg_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.cg_internet_gateway.id
  }

  tags = {
    Name = "CloudGoat Public Route Table"
  }
}

resource "aws_route_table_association" "public_subnet_association_1" {
  subnet_id      = aws_subnet.cg_public_subnet_1.id
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_route_table_association" "public_subnet_association_2" {
  subnet_id      = aws_subnet.cg_public_subnet_2.id
  route_table_id = aws_route_table.public_route_table.id
}

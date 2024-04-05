resource "aws_vpc" "cg-vpc" {
  cidr_block           = "10.10.0.0/16"
  enable_dns_hostnames = true

  tags = {
    Name = "CloudGoat VPC"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "cg-internet-gateway" {
  vpc_id = aws_vpc.cg-vpc.id

  tags = {
    Name = "CloudGoat Internet Gateway"
  }
}

# Public Subnets
resource "aws_subnet" "cg-public-subnet-1" {
  availability_zone = "${var.region}a"
  cidr_block        = "10.10.10.0/24"
  vpc_id            = aws_vpc.cg-vpc.id

  tags = {
    Name = "CloudGoat Public Subnet #1"
  }
}

resource "aws_subnet" "cg-public-subnet-2" {
  availability_zone = "${var.region}b"
  cidr_block        = "10.10.20.0/24"
  vpc_id            = aws_vpc.cg-vpc.

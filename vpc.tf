resource "aws_vpc" "main_vpc" {
  cidr_block           = var.vpc_ip_cidr
  instance_tenancy     = "default"
  enable_dns_support   = "true"
  enable_dns_hostnames = "true"

  tags = {
    Name = "dove-vpc"
  }
}

resource "aws_subnet" "pub-sub" {
  count = length(var.vpc_pub_subnets)

  vpc_id                  = aws_vpc.main_vpc.id
  cidr_block              = var.vpc_pub_subnets[count.index]
  availability_zone       = var.zones[count.index]
  map_public_ip_on_launch = "true"
  tags = {
    Name = "Pub-Sub-${count.index + 1}"
  }

}

resource "aws_subnet" "priv-sub" {
  count = length(var.vpc_priv_subnets)

  vpc_id                  = aws_vpc.main_vpc.id
  cidr_block              = var.vpc_priv_subnets[count.index]
  availability_zone       = var.zones[count.index]
  map_public_ip_on_launch = "true"
  tags = {
    Name = "Pub-Sub-${count.index + 3}"
  }

}

resource "aws_internet_gateway" "pub-igw" {
  vpc_id = aws_vpc.main_vpc.id

  tags = {
    Name = "app-igw"
  }
}

resource "aws_route_table" "pub-RT" {
  vpc_id = aws_vpc.main_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.pub-igw.id
  }

  tags = {
    Name = "pub-RT"
  }
}

resource "aws_route_table_association" "pub-RT-asstn" {
  count = length(aws_subnet.pub-sub)

  subnet_id      = aws_subnet.pub-sub[count.index].id
  route_table_id = aws_route_table.pub-RT.id
}
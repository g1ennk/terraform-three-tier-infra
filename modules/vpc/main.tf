# VPC
resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true # EC2가 DNS 쿼리를 수행할 수 있음
  enable_dns_support   = true # EC2가 퍼블릭 또는 프라이빗 DNS 호스트네임을 가질 수 있음

  tags = merge(var.common_tags, { Name = "main" })
}

# Public Subnets
resource "aws_subnet" "public_subnet_a" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.subnet_cidrs["public_a"]
  availability_zone       = var.availability_zones[0]
  map_public_ip_on_launch = true # 퍼블릭 IP 자동 할당

  tags = merge(var.common_tags, { Name = "public-subnet-a" })
}
resource "aws_subnet" "public_subnet_c" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.subnet_cidrs["public_c"]
  availability_zone       = var.availability_zones[1]
  map_public_ip_on_launch = true # 퍼블릭 IP 자동 할당

  tags = merge(var.common_tags, { Name = "public-subnet-c" })
}

# Private NAT Subnets
resource "aws_subnet" "private_nat_subnet_a" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.subnet_cidrs["private_nat_a"]
  availability_zone       = var.availability_zones[0]
  map_public_ip_on_launch = false # 프라이빗으로 명시적으로 명시

  tags = merge(var.common_tags, { Name = "private-nat-subnet-a" })
}
resource "aws_subnet" "private_nat_subnet_c" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.subnet_cidrs["private_nat_c"]
  availability_zone       = var.availability_zones[1]
  map_public_ip_on_launch = false # 프라이빗으로 명시적으로 명시

  tags = merge(var.common_tags, { Name = "private-nat-subnet-c" })
}

# Private Subnets
resource "aws_subnet" "private_subnet_a" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.subnet_cidrs["private_a"]
  availability_zone       = var.availability_zones[0]
  map_public_ip_on_launch = false # 프라이빗으로 명시적으로 명시

  tags = merge(var.common_tags, { Name = "private-subnet-a" })
}
resource "aws_subnet" "private_subnet_c" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.subnet_cidrs["private_c"]
  availability_zone       = var.availability_zones[1]
  map_public_ip_on_launch = false # 프라이빗으로 명시적으로 명시

  tags = merge(var.common_tags, { Name = "private-subnet-c" })
}

# Internet Gateway 
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = merge(var.common_tags, { Name = "igw" })
}

# Public Route Table
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = merge(var.common_tags, { Name = "public-rt" })
}

# Routing Table Association for Public
resource "aws_route_table_association" "public_rta_a" {
  subnet_id      = aws_subnet.public_subnet_a.id
  route_table_id = aws_route_table.public_rt.id

}
resource "aws_route_table_association" "public_rta_c" {
  subnet_id      = aws_subnet.public_subnet_c.id
  route_table_id = aws_route_table.public_rt.id
}

# Elastic IP for NAT Gateway at A Zone
resource "aws_eip" "nat_gw_eip_a" {
  domain = "vpc"
}
# NAT Gateway at A Zone
resource "aws_nat_gateway" "nat_gw_a" {
  allocation_id = aws_eip.nat_gw_eip_a.id
  subnet_id     = aws_subnet.public_subnet_a.id

  tags = merge(var.common_tags, { Name = "nat-gw-a" })
}

# Elastic IP for NAT Gateway at C Zone
resource "aws_eip" "nat_gw_eip_c" {
  domain = "vpc"
}
# NAT Gateway at C Zone
resource "aws_nat_gateway" "nat_gw_c" {
  allocation_id = aws_eip.nat_gw_eip_c.id
  subnet_id     = aws_subnet.public_subnet_c.id

  tags = merge(var.common_tags, { Name = "nat-gw-c" })
}

# Private Route Table
resource "aws_route_table" "private_rt_a" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gw_a.id
  }

  tags = merge(var.common_tags, { Name = "private-rt-a" })
}

resource "aws_route_table" "private_rt_c" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gw_c.id
  }

  tags = merge(var.common_tags, { Name = "private-rt-c" })
}

# Routing Table Association for Private
resource "aws_route_table_association" "private_rta_a" {
  subnet_id      = aws_subnet.private_nat_subnet_a.id
  route_table_id = aws_route_table.private_rt_a.id

}

resource "aws_route_table_association" "private_rta_c" {
  subnet_id      = aws_subnet.private_nat_subnet_c.id
  route_table_id = aws_route_table.private_rt_c.id
}

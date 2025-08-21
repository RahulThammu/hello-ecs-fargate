# VPC
resource "aws_vpc" "rahul_project_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = merge(
    var.tags,
    {
      Name = "${var.project_name}-${var.environment}-vpc"
    }
  )
}

# Internet Gateway
resource "aws_internet_gateway" "rahul_project_igw" {
  vpc_id = aws_vpc.rahul_project_vpc.id

tags = merge(
    var.tags,
    {
      Name = "${var.project_name}-${var.environment}-igw"
    }
  )
  }

# Public Subnet 1
resource "aws_subnet" "rahul_project_public_1" {
  vpc_id                  = aws_vpc.rahul_project_vpc.id
  cidr_block              = "10.0.101.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true

 tags = merge(
    var.tags,
    {
      Name = "${var.project_name}-${var.environment}-pub-sub-1"
    }
  )
}

# Public Subnet 2
resource "aws_subnet" "rahul_project_public_2" {
  vpc_id                  = aws_vpc.rahul_project_vpc.id
  cidr_block              = "10.0.102.0/24"
  availability_zone       = "us-east-1b"
  map_public_ip_on_launch = true

 tags = merge(
    var.tags,
    {
      Name = "${var.project_name}-${var.environment}-pub-sub-2"
    }
  )
}

# Private Subnet 1
resource "aws_subnet" "rahul_project_private_1" {
  vpc_id            = aws_vpc.rahul_project_vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1a"

 tags = merge(
    var.tags,
    {
      Name = "${var.project_name}-${var.environment}-priv-sub-1"
    }
  )
}

# Private Subnet 2
resource "aws_subnet" "rahul_project_private_2" {
  vpc_id            = aws_vpc.rahul_project_vpc.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-east-1b"

 tags = merge(
    var.tags,
    {
      Name = "${var.project_name}-${var.environment}priv-sub-2"
    }
  )
}

# Elastic IP for NAT Gateway
resource "aws_eip" "rahul_project_nat_eip" {
  domain = "vpc"
}


# NAT Gateway
resource "aws_nat_gateway" "rahul_project_nat" {
  allocation_id = aws_eip.rahul_project_nat_eip.id
  subnet_id     = aws_subnet.rahul_project_public_1.id

 tags = merge(
    var.tags,
    {
      Name = "${var.project_name}-${var.environment}-ngw"
    }
  )

  depends_on = [aws_internet_gateway.rahul_project_igw]
}

# Public Route Table
resource "aws_route_table" "rahul_project_public_rt" {
  vpc_id = aws_vpc.rahul_project_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.rahul_project_igw.id
  }

  tags = merge(
    var.tags,
    {
      Name = "${var.project_name}-${var.environment}-pub-rt"
    }
  )
}

# Private Route Table
resource "aws_route_table" "rahul_project_private_rt" {
  vpc_id = aws_vpc.rahul_project_vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.rahul_project_nat.id
  }

 tags = merge(
    var.tags,
    {
      Name = "${var.project_name}-${var.environment}-priv-rt"
    }
  )
}

# Route Table Associations
resource "aws_route_table_association" "rahul_project_public_1" {
  subnet_id      = aws_subnet.rahul_project_public_1.id
  route_table_id = aws_route_table.rahul_project_public_rt.id
}

resource "aws_route_table_association" "rahul_project_public_2" {
  subnet_id      = aws_subnet.rahul_project_public_2.id
  route_table_id = aws_route_table.rahul_project_public_rt.id
}

resource "aws_route_table_association" "rahul_project_private_1" {
  subnet_id      = aws_subnet.rahul_project_private_1.id
  route_table_id = aws_route_table.rahul_project_private_rt.id
}

resource "aws_route_table_association" "rahul_project_private_2" {
  subnet_id      = aws_subnet.rahul_project_private_2.id
  route_table_id = aws_route_table.rahul_project_private_rt.id
}
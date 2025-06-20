resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name        = "tuai-${var.environment}-vpc"
    Environment = var.environment
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name        = "tuai-${var.environment}-igw"
    Environment = var.environment
  }
}

# Public Subnets
resource "aws_subnet" "public_a" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-east-2a"
  map_public_ip_on_launch = true

  tags = {
    Name        = "tuai-${var.environment}-public-a"
    Environment = var.environment
  }
}

//  resource "aws_subnet" "public_b" {
//  vpc_id                  = aws_vpc.main.id
//  cidr_block              = "10.0.2.0/24"
//  availability_zone       = "us-east-2b"
//  map_public_ip_on_launch = true
//
//  tags = {
//    Name        = "tuai-${var.environment}-public-b"
//    Environment = var.environment
//  }
// }


# Private Subnets
resource "aws_subnet" "private_a" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.101.0/24"
  availability_zone = "us-east-2a"

  tags = {
    Name        = "tuai-${var.environment}-private-a"
    Environment = var.environment
  }
}

//resource "aws_subnet" "private_b" {
//  vpc_id            = aws_vpc.main.id
//  cidr_block        = "10.0.102.0/24"
//  availability_zone = "us-east-2b"
//
//  tags = {
//    Name        = "tuai-${var.environment}-private-b"
//    Environment = var.environment
//  }
// }

# NAT Gateway Setup in one public subnet (using public_a)
resource "aws_eip" "nat_eip" {


  depends_on = [aws_internet_gateway.igw]
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public_a.id

  tags = {
    Name        = "tuai-${var.environment}-nat"
    Environment = var.environment
  }
}

# Public Route Table (routes to Internet Gateway)
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name        = "tuai-${var.environment}-public-rt"
    Environment = var.environment
  }
}

resource "aws_route_table_association" "public_a_assoc" {
  subnet_id      = aws_subnet.public_a.id
  route_table_id = aws_route_table.public_rt.id
}

// resource "aws_route_table_association" "public_b_assoc" {
//  subnet_id      = aws_subnet.public_b.id
//  route_table_id = aws_route_table.public_rt.id
// }

# Private Route Table (routes outbound via NAT Gateway)
resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
  }

  tags = {
    Name        = "tuai-${var.environment}-private-rt"
    Environment = var.environment
  }
}

resource "aws_route_table_association" "private_a_assoc" {
  subnet_id      = aws_subnet.private_a.id
  route_table_id = aws_route_table.private_rt.id
}

// resource "aws_route_table_association" "private_b_assoc" {
//  subnet_id      = aws_subnet.private_b.id
//  route_table_id = aws_route_table.private_rt.id
// }

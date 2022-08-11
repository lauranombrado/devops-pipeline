# Define the public subnets
resource "aws_subnet" "public-subnet" {
  vpc_id = aws_vpc.default.id
  cidr_block = var.public_subnet_a_cidr
  availability_zone = "us-east-1a"

  tags = {
    Name = "Web Public Subnet 1"
  }
}

resource "aws_subnet" "public-subnet2" {
  vpc_id = aws_vpc.default.id
  cidr_block = var.public_subnet_b_cidr
  availability_zone = "us-east-1b"

  tags = {
    Name = "Web Public Subnet 2"
  }
}

# Define the private subnets
resource "aws_subnet" "private-subnet" {
  vpc_id = aws_vpc.default.id
  cidr_block = var.private_subnet_a_cidr
  availability_zone = "us-east-1a"

  tags = {
    Name = "App Private Subnet 1"
  }
}

resource "aws_subnet" "private-subnet2" {
  vpc_id = aws_vpc.default.id
  cidr_block = var.private_subnet_b_cidr
  availability_zone = "us-east-1b"

  tags = {
    Name = "App Private Subnet 2"
  }
}

# Define the DB subnets
resource "aws_subnet" "private-db-subnet" {
  vpc_id = aws_vpc.default.id
  cidr_block = var.private_db_subnet_a_cidr
  availability_zone = "us-east-1a"

  tags = {
    Name = "DB Private Subnet 1"
  }
}

resource "aws_subnet" "private-db-subnet2" {
  vpc_id = aws_vpc.default.id
  cidr_block = var.private_db_subnet_b_cidr
  availability_zone = "us-east-1b"

  tags = {
    Name = "DB Private Subnet 2"
  }
}

# Define DB Subnet Group
resource "aws_db_subnet_group" "default" {
  name = "main-subnet-group"
  subnet_ids = [ aws_subnet.private-db-subnet.id, aws_subnet.private-db-subnet2.id ]
  tags = {
    Name = "DB subnet group"
  }
}

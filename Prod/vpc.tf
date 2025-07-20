
# To create a VPC 
resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr

  tags = {
    Name = var.vpc_name
  }
}

# TO create a Public Subnet 
resource "aws_subnet" "mypublic" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_cidr
  map_public_ip_on_launch = true
  availability_zone       = "${var.aws_region}a"

  tags = {
    Name = var.public_subnet_name
  }
}

# To create private Subnet-1
resource "aws_subnet" "myprivate1" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnet_cidr_1
  availability_zone = "${var.aws_region}b"

  tags = {
    Name = "${var.private_subnet_name}1"
  }
}

# To create private Subnet-2
resource "aws_subnet" "myprivate2" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnet_cidr_2
  availability_zone = "${var.aws_region}c"

  tags = {
    Name = "${var.private_subnet_name}2"
  }
}

# To create Internet Gateway for Public Subnet 
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "main-igw"
  }
}

# To create route table and allow all
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "public-route-table"
  }
}

# To associate route table with 
resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.mypublic.id
  route_table_id = aws_route_table.public.id
}

# TO create a EIP 
resource "aws_eip" "nat" {
  domain = "vpc"
}

# TO  create a Nat Gateway 
resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.mypublic.id

  tags = {
    Name = "main-nat"
  }
}

# To create route table for private Subnet 
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
  }

  tags = {
    Name = "private-route-table"
  }
}

# To associate private subnet-1 with route table
resource "aws_route_table_association" "private-1" {
  subnet_id      = aws_subnet.myprivate1.id
  route_table_id = aws_route_table.private.id
}
# To associate private subnet-2 with route table
resource "aws_route_table_association" "private-2" {
  subnet_id      = aws_subnet.myprivate2.id
  route_table_id = aws_route_table.private.id
}

/*
# Create NACL for Public Subnat 
resource "aws_network_acl" "public_nacl" {
  vpc_id = aws_vpc.main.id

  ingress {
    rule_no    = 100
    action     = "allow"
    protocol   = "tcp"
    cidr_block = "0.0.0.0/0"
    from_port  = 80
    to_port    = 80
  }

  egress {
    rule_no    = 100
    action     = "allow"
    protocol   = "-1"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  tags = {
    Name = "public-nacl"
  }
}

# Create NACL for Private Subnet 
resource "aws_network_acl" "private_nacl" {
  vpc_id = aws_vpc.main.id

  ingress {
    rule_no    = 100
    action     = "allow"
    protocol   = "tcp"
    cidr_block = "10.0.0.0/16"
    from_port  = 0
    to_port    = 65535
  }

  egress {
    rule_no    = 100
    action     = "allow"
    protocol   = "-1"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  tags = {
    Name = "private-nacl"
  }
}

# Associate NACL with Public Subnet 
resource "aws_network_acl_association" "public_nacl_association" {
  subnet_id      = aws_subnet.mypublic.id
  network_acl_id = aws_network_acl.public_nacl.id
}

# Associate NACL with Private Subnet 
resource "aws_network_acl_association" "private_nacl_association" {
  subnet_id      = aws_subnet.myprivate.id
  network_acl_id = aws_network_acl.private_nacl.id
}
*/
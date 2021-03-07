# Network configuration

# VPC creation
resource "aws_vpc" "terraform" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  tags = {
    Name = "vpc-http"
  }
}

# http subnet configuration
resource "aws_subnet" "http" {
  vpc_id     = aws_vpc.terraform.id
  cidr_block = var.subnet_cidr
  tags = {
    Name = "subnet-http"
  }
  depends_on = [aws_internet_gateway.gw]
}

# http subnet configuration
resource "aws_subnet" "private_subnet" {
  vpc_id     = aws_vpc.terraform.id
  cidr_block = var.private_subnet_cdr
  tags = {
    Name = "subnet-private"
  }
}

# External gateway configuration
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.terraform.id
  tags = {
    Name = "internet-gateway"
  }
}

# Create ande associate route

# Routing table configuration
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.terraform.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }
}

# Associate http route
resource "aws_route_table_association" "http" {
  subnet_id      = aws_subnet.http.id
  route_table_id = aws_route_table.public.id
}

# Associate private route
resource "aws_route_table_association" "private_subnet" {
  subnet_id      = aws_subnet.private_subnet.id
  route_table_id = aws_route_table.public.id
}

# Security group configuration

# Default administration port
resource "aws_security_group" "web" {
  name        = "web"
  description = "Allow web access"
  vpc_id      =  aws_vpc.terraform.id
  tags = {
    Name = "web-sg"
  }

  # Open ssh port
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow icmp
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Open access to public network
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

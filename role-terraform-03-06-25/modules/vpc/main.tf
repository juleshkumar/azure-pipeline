data "aws_availability_zones" "available" {
  state = "available"
}

locals {
  constant_vpc_tags = {
    Name        = "${var.customer_name}-${var.Environment}-VPC"
    Environment = var.Environment
    ManagedBy   = "Terraform"
  }
}

resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = merge(
    local.constant_vpc_tags,
    var.vpc_tags
  )
}


resource "aws_subnet" "public_1" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_1_cidr
  availability_zone       = data.aws_availability_zones.available.names[0]
  map_public_ip_on_launch = true

  tags = merge(var.vpc_tags, {
    "Name" = "${var.customer_name}-${var.Environment}-public-subnet-1-${data.aws_availability_zones.available.names[0]}"
  })
}

resource "aws_subnet" "private_1" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnet_1_cidr
  availability_zone = data.aws_availability_zones.available.names[0]

  tags = merge(var.vpc_tags, {
    "Name" = "${var.customer_name}-${var.Environment}-private-subnet-1-${data.aws_availability_zones.available.names[0]}"
  })
}

resource "aws_subnet" "private_2" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnet_2_cidr
  availability_zone = data.aws_availability_zones.available.names[1]

  tags = merge(var.vpc_tags, {
    "Name" = "${var.customer_name}-${var.Environment}-private-subnet-2-${data.aws_availability_zones.available.names[1]}"
  })
}


resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name        = "${var.customer_name}-${var.Environment}-igw"
    Environment = var.Environment
    ManagedBy   = "Terraform"
  }
}


resource "aws_eip" "nat" {
-  vpc = true
  tags = {
    "Name" = "${var.customer_name}-${var.Environment}-nat-gateway-ip"
  }
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public_1.id
  tags = {
    "Name" = "${var.customer_name}-${var.Environment}-nat-gateway"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name        = "${var.customer_name}-${var.Environment}-public-route-table"
    Environment = var.Environment
  }
}

resource "aws_route" "public_internet_gateway" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

resource "aws_route_table_association" "public_subnet_1_assoc" {
  subnet_id      = aws_subnet.public_1.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id
  tags = merge(var.vpc_tags, {
    "Name" = "${var.customer_name}-${var.Environment}-private-route-table"
    "Environment" = var.Environment
  })
}

resource "aws_route" "private_subnet_route" {
  route_table_id         = aws_route_table.private.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat.id
}

resource "aws_route_table_association" "private_subnet_1_assoc" {
  subnet_id      = aws_subnet.private_1.id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "private_subnet_2_assoc" {
  subnet_id      = aws_subnet.private_2.id
  route_table_id = aws_route_table.private.id
}

resource "aws_security_group" "sg" {
  name        = "${var.customer_name}-${var.Environment}-default-sg"
  description = "Default SG to allow traffic from the VPC"
  vpc_id      = aws_vpc.main.id
  depends_on  = [aws_vpc.main]

  ingress {
    from_port = 0
    to_port   = 0
    protocol  = -1
    self      = true
  }

  egress {
    from_port = 0
    to_port   = 0
    protocol  = -1
    self      = true
  }

  tags = {
    Environment = var.Environment
  }
}

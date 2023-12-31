# create an aws vpc for kubernetes
resource "aws_vpc" "main_vpc" {
  cidr_block = var.vpc_cidr_block
  tags = {
    Name = "VPC_Kubernetes"
  }
}

# create an internet gateway for kubernetes
resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = aws_vpc.main_vpc.id
  tags = {
    Name = "Internet_Gateway_Kubernetes"
  }
}

#####--------------PUBLIC Subnets--------------#####

# create public subnets for kubernetes
resource "aws_subnet" "public_subnet" {
  count                   = length(var.public_subnet_cidr)
  vpc_id                  = aws_vpc.main_vpc.id
  cidr_block              = var.public_subnet_cidr[count.index]
  map_public_ip_on_launch = true
  tags = {
    Name = "Subnet_Public_Kubernetes-${var.env}-${count.index + 1}"
  }
}

# create a route table for public subnets in kubernetes
resource "aws_route_table" "route_tables_public" {
  vpc_id = aws_vpc.main_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet_gateway.id
  }
  tags = {
    Name = "Route_Tables_Public_Kubernetes-${var.env}"
  }
}

# associate route tables with public subnets
resource "aws_route_table_association" "public_association" {
  count          = length(var.private_subnet_cidr)
  route_table_id = aws_route_table.route_tables_public.id
  subnet_id      = element(aws_subnet.public_subnet[*].id, count.index)

}


#####--------------PRIVATE Subnets--------------#####


# create private subnets for kubernetes
resource "aws_subnet" "private_subnet" {
  count      = length(var.private_subnet_cidr)
  vpc_id     = aws_vpc.main_vpc.id
  cidr_block = var.private_subnet_cidr[count.index]
  tags = {
    Name = "Subnet_Private_Kubernetes-${var.env}-${count.index + 1}"
  }
}

# create route tables for private subnets in kubernetes
resource "aws_route_table" "route_tables_private" {
  count  = length(var.private_subnet_cidr)
  vpc_id = aws_vpc.main_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat[count.index].id
  }
  tags = {
    Name = "Route_Tables_Private_Kubernetes-${var.env}-${count.index + 1}"
  }
}

# associate route tables with private subnets
resource "aws_route_table_association" "private_association" {
  count          = length(aws_subnet.private_subnet[*].id)
  route_table_id = aws_route_table.route_tables_private[count.index].id
  subnet_id      = aws_subnet.private_subnet[count.index].id
}

resource "aws_eip" "nat" {
  count  = length(var.private_subnet_cidr)
  domain = "vpc"
  tags = {
    Name = "${var.env}-Elastic_IP-${count.index + 1}"
  }
}

resource "aws_nat_gateway" "nat" {
  count         = length(var.private_subnet_cidr)
  allocation_id = aws_eip.nat[count.index].id
  subnet_id     = element(aws_subnet.public_subnet[*].id, count.index)
  tags = {
    Name = "${var.env}-NAT-Gateway-${count.index + 1}"
  }

}
# variable for the cidr block of the vpc
variable "vpc_cidr_block" {
  description = "cidr block for the vpc"
  default     = "10.10.0.0/16"
}

variable "env" {
  default = "DEV"
}

variable "public_subnet_cidr" {
  default = [
    "10.10.20.0/24",
    "10.10.21.0/24"
  ]
}

variable "private_subnet_cidr" {
  default = [
    "10.10.10.0/24",
    "10.10.11.0/24"
  ]
}

output "vpc_id" {
  value = aws_vpc.main_vpc.id
}
output "public_subnet_ids" {
  value = aws_subnet.public_subnet[*].id
}
output "private_subnet_ids" {
  value = aws_subnet.private_subnet[*].id
}

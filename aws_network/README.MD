# AWS Terraform Module: VPC with Public and Private Subnets

This Terraform module facilitates the creation of an Amazon Virtual Private Cloud (VPC) in AWS, configured with public and private subnets. The module provisions the following components:

## Variables
- **project_name:** A unique identifier for the project (default: "default").
- **vpc_cidr_block:** The CIDR block for the VPC (default: "10.10.0.0/16").
- **env:** The environment identifier (default: "default").
- **public_subnet_cidr:** List of CIDR blocks for public subnets.
- **private_subnet_cidr:** List of CIDR blocks for private subnets.

## VPC and Internet Gateway
- **aws_vpc.main_vpc:** Creates an AWS VPC with the specified CIDR block.
- **aws_internet_gateway.internet_gateway:** Creates an Internet Gateway and associates it with the VPC.

## Public Subnets
- **aws_subnet.public_subnet:** Creates public subnets within the VPC.
- **aws_route_table.route_tables_public:** Creates a route table for public subnets and associates it with an Internet Gateway.
- **aws_route_table_association.public_association:** Associates the route table with public subnets.

## Private Subnets
- **aws_subnet.private_subnet:** Creates private subnets within the VPC.
- **aws_route_table.route_tables_private:** Creates route tables for private subnets with a default route through NAT Gateways.
- **aws_route_table_association.private_association:** Associates the route tables with private subnets.
- **aws_eip.nat:** Allocates Elastic IPs for NAT Gateways.
- **aws_nat_gateway.nat:** Creates NAT Gateways in public subnets and associates them with Elastic IPs.

## Outputs
- **vpc_id:** Outputs the ID of the created VPC.
- **public_subnet_ids:** Outputs the IDs of the created public subnets.
- **private_subnet_ids:** Outputs the IDs of the created private subnets.

This Terraform module provides a foundation for setting up a secure and scalable AWS infrastructure with separate public and private network segments. It is suitable for deploying applications that require both internet-facing and internal components, such as Kubernetes clusters. Adjust the variables as needed to tailor the VPC to your specific requirements.

## Examples
# AWS VPC Terraform Module

This Terraform module creates an Amazon Virtual Private Cloud (VPC) with public and private subnets.

## Usage

### Development Environment

```hcl
module "vpc-dev" {
  source              = "git@github.com:dimadolgov/Terraform_Modules.git//aws_network"
  project_name        = "Project_DEV"
  env                 = "development"
  vpc_cidr_block      = "30.30.0.0/16"
  public_subnet_cidr  = ["30.30.10.0/24", "30.30.11.0/24"]
  private_subnet_cidr = []
}

module "vpc-prod" {
  source              = "git@github.com:dimadolgov/Terraform_Modules.git//aws_network"
  project_name        = "Project_PROD"
  env                 = "production"
  vpc_cidr_block      = "30.30.0.0/16"
  public_subnet_cidr  = ["30.30.10.0/24", "30.30.11.0/24", "30.30.12.0/24", "30.30.13.0/24"]
  private_subnet_cidr = ["30.30.20.0/24", "30.30.21.0/24"]
}


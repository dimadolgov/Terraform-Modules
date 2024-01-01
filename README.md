module "vpc-dev" {
  source              = "git@github.com:dimadolgov/Terraform_Modules.git//aws_network"
  project_name        = "Project_DEV"
  env                 = "Development"
  vpc_cidr_block      = "30.30.0.0/16"
  public_subnet_cidr  = ["30.30.10.0/24", "30.30.11.0/24"]
  private_subnet_cidr = []
}

module "vpc-prod" {
  source              = "git@github.com:dimadolgov/Terraform_Modules.git//aws_network"
  project_name        = "Project_PROD"
  env                 = "Production"
  vpc_cidr_block      = "30.30.0.0/16"
  public_subnet_cidr  = ["30.30.20.0/24", "30.30.21.0/24"]
  private_subnet_cidr = ["30.30.30.0/24", "30.30.31.0/24"]
}

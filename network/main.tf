# terraform {
#   cloud {
#     organization = "croffle_ma_sit_dda"
#     workspaces {
#       name = "mkhong"
#     }
#   }
# }

terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.region_set
}

module "vpc" {
  source          = "terraform-aws-modules/vpc/aws"
  name            = var.vpc_name
  cidr            = var.cidr
  azs             = var.azs
  private_subnets = var.private_subnets
  private_subnet_names = var.private_subnet_names
  public_subnets  = var.public_subnets
  public_subnet_names = var.public_subnet_names

  enable_nat_gateway = true
  single_nat_gateway = true
  one_nat_gateway_per_az = false
  enable_vpn_gateway = false

  tags = {
    Terraform   = "true"
    Environment = var.env_set
  }

}

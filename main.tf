terraform {
  cloud {
    organization = "croffle_ma_sit_dda"
    workspaces {
      name = "mkhong"
    }
  }
}

provider "aws" {
  region = "ap-northeast-1"
}

module "vpc" {
  source          = "terraform-aws-modules/vpc/aws"
  name            = "dev-vpc"
  cidr            = "172.16.0.0/16"
  azs             = ["ap-northeast-1a", "ap-northeast-1c", "ap-northeast-1d"]
  private_subnets = ["172.16.15.0/24", "172.16.25.0/24", "172.16.35.0/24"]
  public_subnets  = ["172.16.10.0/24", "172.16.20.0/24", "172.16.30.0/24"]

  enable_nat_gateway     = true
  single_nat_gateway     = true
  one_nat_gateway_per_az = false
  enable_vpn_gateway     = false

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }

}


module "dev_security_group" {
  source = "terraform-aws-modules/security-group/aws"

  name        = "dev-service-sg"
  description = "Security group for user-service with ports "
  vpc_id      = module.vpc.vpc_id
  ingress_with_cidr_blocks = [
    {
      rule        = "ssh-tcp"
      cidr_blocks = "210.217.38.19/32"
      description = "ssh connection"
    }
  ]
}


# module "key_pair" {
#     source = "terraform-aws-modules/key-pair/aws"
#     key_name = "aws-ec2-ne1-key"
# }


module "ec2_instance" {
  source                 = "terraform-aws-modules/ec2-instance/aws"
  name                   = "terraform-test-instance"
  ami                    = "ami-06aa91d03bbe9eed7"
  instance_type          = "t3.micro"
  key_name               = "aws-ec2-ne1-key"
  monitoring             = true
  vpc_security_group_ids = [module.dev_security_group.security_group_id]
  subnet_id              = element(module.vpc.public_subnets, length(module.vpc.private_subnets))
  create_eip             = true
  tags = {
    Terraform   = "true"
    Environment = "dev"
    Name        = "openvpn"
  }
}
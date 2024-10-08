provider "aws" {
  region = var.region_set
}

data "aws_vpc" "region_vpc" {
  tags = {
    Environment = var.env_set
  }
}

data "aws_subnet" "first_public_subnet" {
  tags = {
    Name = var.public_subnet_names[0]
  }
}

module "connection_sg" {
  source = "terraform-aws-modules/security-group/aws"

  name        = "connection_sg"
  description = "bastion connection security group"
  vpc_id      = data.aws_vpc.region_vpc.id
  ingress_with_cidr_blocks = [
    {
      rule        = "ssh-tcp"
      cidr_blocks = "210.217.38.19/32"
      description = "ssh connection"
    }
  ]
  tags = {
    Terraform = "true"
    Environment = var.env_set
  }
}

module "ec2_instance" {
    source = "terraform-aws-modules/ec2-instance/aws"
    name = "terraform-test-instance"
    ami = "ami-06aa91d03bbe9eed7"
    instance_type = "t3.micro"
    key_name      = "aws-ec2-ne1-key"
    monitoring = true
    vpc_security_group_ids = [module.connection_sg.security_group_id]
    subnet_id = data.aws_subnet.first_public_subnet.id
    create_eip = true
    tags = {
        Terraform = "true"
        Environment = var.env_set
        Name = "openvpn"
    }
}
module "connection_sg" {
  source = "terraform-aws-modules/security-group/aws"

  name        = "connection_sg"
  description = "bastion connection security group"
  vpc_id      = module.vpc.vpc_id
  ingress_with_cidr_blocks = [
    {
      rule        = "ssh-tcp"
      cidr_blocks = "210.217.38.19/32"
      description = "ssh connection"
    }
  ]
}


module "key_pair" {
    source = "terraform-aws-modules/key-pair/aws"
    key_name = "aws-ec2-ne1-key"
}


module "ec2_instance" {
    source = "terraform-aws-modules/ec2-instance/aws"
    name = "terraform-test-instance"
    ami = "ami-06aa91d03bbe9eed7"
    instance_type = "t3.micro"
    key_name      = "aws-ec2-ne1-key"
    monitoring = true
    vpc_security_group_ids = [module.dev_security_group.security_group_id]
    subnet_id = element(module.vpc.public_subnets, length(module.vpc.private_subnets))
    create_eip = true
    tags = {
        Terraform = "true"
        Environment = "dev"
        Name = "openvpn"
    }
}
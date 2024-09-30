variable "env_set" {
  description = "environment"
  type = string
}

variable "azs" {
  description = "Available zone"
  type = list(string)
}

variable "vpc_name" {
  description = "vpc name"
  type = string
}

variable "cidr" {
    description = "vpc cidr"
    type = string
  
}

variable "private_subnets" {
    description = "private subnet"
    type = list(string)
}

variable "public_subnets" {
    description = "public subnet"
    type = list(string)
}
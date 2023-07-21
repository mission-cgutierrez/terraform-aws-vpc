variable "name" {
  type        = string
  description = "The name of the VPC"
}

variable "vpc_cidr_block" {
  type        = string
  description = "The CIDR block for the VPC"
}

variable "region" {
  type        = string
  description = "The AWS region"
}

variable "private_subnets" {
  type        = list(object({
    cidr_block        = string
    availability_zone = string
  }))
  description = "List of private subnet CIDR blocks and availability zones"
}

variable "public_subnets" {
  type        = list(object({
    cidr_block        = string
    availability_zone = string
  }))
  description = "List of public subnet CIDR blocks and availability zones"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "public_subnet_1_cidr" {
  description = "CIDR block for the first public subnet"
  type        = string
}

variable "private_subnet_1_cidr" {
  description = "CIDR block for the first private subnet"
  type        = string
}

variable "private_subnet_2_cidr" {
  description = "CIDR block for the second private subnet"
  type        = string
}

variable "vpc_tags" {
  description = "Tags for the VPC"
  type        = map(string)
}

variable "Environment" {
  type        = string
  description = "Environment for vpc"
}

variable "cluster-name" {
  description = "The name of the cluster"
  type        = string
}

variable "customer_name" {
  description = "Enter name of the customer"
  type        = string
}
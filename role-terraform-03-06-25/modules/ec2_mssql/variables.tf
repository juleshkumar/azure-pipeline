variable "mssql_ami" {
  type        = string
  description = "The ID of the Amazon Machine Image (AMI) used to launch the instance"
}

variable "mssql_ec2_instance_type" {
  type        = string
  description = "The type of EC2 instance to launch"
}

variable "ec2_mssql_tags" {
  type = map(string)
}

variable "customer_name" {
  type        = string
  description = "enter customer name"
}

variable "Environment" {
  type        = string
  description = "enter Environment name"
}

variable "private_subnet1" {
  type = string
}


variable "cmk_arn" {
  type        = string
}

variable "ec2_mssql_volume_size" {
  type        = number
  description = "Root EBS volume size in GiB"
}

variable "vpc_id" {
  type        = string
}

variable "vpc_cidr_block" {
  type        = string
}

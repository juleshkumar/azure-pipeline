variable "rds_db_instance_identifier" {
  type        = string
  description = "Please mention the Database Instance Identifier"
}

variable "rds_database_name" {
  type        = string
  description = "rds Database Name"
}

variable "common_secret_name" {
  type        = string
}

variable "major_version" {
  type        = string
  description = "rds Database Parameter Group Major Version"
}

variable "engine_version" {
  type        = string
  description = "rds Database Engine Version"
}

variable "customer_name" {
  type        = string
  description = "Enter customer name"
}

variable "rds_db_instance_type" {
  type        = string
  description = "rds Database Instance Type"
}

variable "rds_db_allocated_storage" {
  type        = string
  description = "rds Database Storage Size"
}

variable "rds_port" {
  type        = string
  description = "rds CIDR Range"
}
variable "rds_tags" {
  type = map(string)
}

variable "vpc_cidr_block" {
  type        = string
}

variable "private_subnet_ids" {
  type        = list(string)
}

variable "vpc_id" {
  type        = string
}

variable "cmk_arn" {
  type        = string
}

variable "Environment" {
  type        = string
}
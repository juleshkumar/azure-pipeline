variable "rds_db_instance_identifier" {
  type        = string
  description = "Please mention the Database Instance Identifier"
}

variable "rds_database_name" {
  type        = string
  description = "RDS Database Name"
  default     = null  # MSSQL doesn't require a database name at creation
}

variable "common_secret_name" {
  type        = string
  description = "Name of the secret in AWS Secrets Manager for MSSQL credentials"
}

variable "major_version" {
  type        = string
  description = "MSSQL Database Parameter Group Major Version (e.g., 15.00, 14.00)"
}

variable "engine_version" {
  type        = string
  description = "MSSQL Database Engine Version (e.g., 15.00.4236.7.v1)"
}

variable "edition" {
  type        = string
  description = "MSSQL edition (e.g., ee, se, ex, web)"
  validation {
    condition     = contains(["ee", "se", "ex", "web"], var.edition)
    error_message = "Valid values for edition are: ee (Enterprise), se (Standard), ex (Express), web (Web)."
  }
}

variable "customer_name" {
  type        = string
  description = "Enter customer name"
}

variable "rds_db_instance_type" {
  type        = string
  description = "RDS Database Instance Type"
}

variable "rds_db_allocated_storage" {
  type        = string
  description = "RDS Database Storage Size"
}

variable "rds_port" {
  type        = string
  description = "RDS Port Number"
  default     = "1433"
}

variable "rds_tags" {
  type = map(string)
  description = "Tags for MSSQL resources"
}

variable "vpc_cidr_block" {
  type = string
  description = "VPC CIDR block"
}

variable "private_subnet_ids" {
  type = list(string)
  description = "List of private subnet IDs"
}

variable "vpc_id" {
  type = string
  description = "VPC ID"
}

variable "cmk_arn" {
  type = string
  description = "ARN of the KMS key for encryption"
}

variable "Environment" {
  type = string
  description = "Environment name"
}

variable "multi_az" {
  type        = bool
  description = "Enable Multi-AZ deployment"
  default     = false
}

variable "backup_retention_period" {
  type        = number
  description = "Number of days to retain backups"
  default     = 7
}

variable "backup_window" {
  type        = string
  description = "Preferred backup window"
  default     = "03:00-06:00"
}

variable "maintenance_window" {
  type        = string
  description = "Preferred maintenance window"
  default     = "sun:06:00-sun:10:00"
}

variable "timezone" {
  type        = string
  description = "Time zone of the DB instance"
  default     = "Eastern Standard Time"
}

variable "character_set_name" {
  type        = string
  description = "Character set name for MSSQL"
  default     = "SQL_Latin1_General_CP1_CI_AS"
}

variable "backup_restore_role_arn" {
  type        = string
  description = "ARN of the IAM role for SQLSERVER_BACKUP_RESTORE option"
  default     = ""
}
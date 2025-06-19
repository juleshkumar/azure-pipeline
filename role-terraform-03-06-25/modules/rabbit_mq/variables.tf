variable "customer_name" {
  description = "Enter name of the customer"
  type        = string
}

variable "mq_engine_version" {
  description = "RabbitMQ engine version"
  type        = string
}

variable "host_instance_type" {
  description = "Instance type for the broker"
  type        = string
}

variable "deployment_mode" {
  description = "Deployment mode - SINGLE_INSTANCE or ACTIVE_STANDBY_MULTI_AZ"
  type        = string
}

variable "publicly_accessible" {
  description = "Whether the broker is publicly accessible"
  type        = bool
}

variable "auto_minor_version_upgrade" {
  description = "Enable automatic minor version upgrades"
  type        = bool
}

variable "apply_immediately" {
  description = "Apply changes immediately"
  type        = bool
}

variable "private_subnet1" {
  description = "List of subnet IDs for the broker"
  type        = string
}

variable "logs_general" {
  description = "Enable general logging"
  type        = bool
}

variable "maintenance_day" {
  description = "Preferred maintenance day"
  type        = string
}

variable "maintenance_time" {
  description = "Preferred maintenance start time"
  type        = string
}

variable "maintenance_timezone" {
  description = "Timezone for maintenance window"
  type        = string
}

variable "common_secret_name" {
  type        = string
}

variable "console_access" {
  description = "Allow user console access"
  type        = bool
}

variable "user_groups" {
  description = "Groups to which the user belongs"
  type        = list(string)
}

variable "vpc_id" {
  description = "VPC ID for security group"
  type        = string
}

variable "Environment" {
  description = "Security group name"
  type        = string
}

variable "vpc_cidr_block" {
  description = "CIDR blocks allowed to access RabbitMQ"
  type        = string
}

variable "mq_tags" {
  description = "Tags to assign to resources"
  type        = map(string)
}

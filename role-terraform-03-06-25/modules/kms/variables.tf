variable "customer_name" {
  type        = string
  description = "Enter customer name"
}

variable "kms_tags" {
  type = map(string)
  
}

variable "account_id" {
  description = "AWS Account ID"
  type        = string
}

variable "Environment" {
  type        = string
  description = "Enter Environment name"
}

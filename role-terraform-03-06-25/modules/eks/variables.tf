variable "k8s_version" {
  description = "Kubernetes version."
  type        = string
}


variable "cluster-name" {
  description = "The name of the cluster"
  type        = string
}

variable "eks_tags" {
  type = map(string)
}

variable "customer_name" {
  type        = string
  description = "Enter customer name"
}

variable "Environment" {
  type        = string
  description = "Enter Environment name"
}

variable "private_subnet_ids" {
  type        = list(string)
}

variable "vpc_cidr_block" {
  type        = string
}

variable "vpc_id" {
  type        = string
}

variable "cmk_arn" {
  type        = string
}
variable "cluster-name" {
  description = "The name of the EKS cluster"
  type        = string
}

variable "k8s_version" {
  description = "Kubernetes version."
  type        = string
}

variable "cloudwatch_logs" {
  type        = bool
  description = "Setup full CloudWatch logging."
}

variable "Environment" {
  type        = string
  description = "The environment name (e.g., production, staging)."
}

variable "ec2_root_volume_size" {
  type        = string
}

variable "customer_name" {
  type        = string
}

variable "eks_cluster_sg_id" {
  type        = string
}

variable "vpc_id" {
  type        = string
}

variable "vpc_cidr_block" {
  type        = string
}

variable "eks_cluster_id" {
  type        = string
}

variable "cmk_arn" {
  type        = string
}

variable "private_subnet_ids" {
  type        = list(string)
}


variable "node_groups_test" {
  description = "List of node groups with specific ingress and egress rules"
  type = list(object({
    name            = string
    instance_types  = list(string)
    ng_test_tags = map(string)
    labels          = map(string)
    tolerations     = object({
      key    = string
      value  = string
      effect = string
    })
    minimum_size    = number
    maximum_size    = number
    desired_size    = number
    capacity_type   = string
  }))
}

variable "node_groups_test_tt" {
  description = "List of node groups with specific ingress and egress rules"
  type = list(object({
    name            = string
    instance_types  = list(string)
    ng_test_tags = map(string)
    labels          = map(string)
    minimum_size    = number
    maximum_size    = number
    desired_size    = number
    capacity_type   = string

  }))
}
variable "customer_name" {
  type        = string
  description = "Enter name of the customer"
}

variable "internal" {
  description = "Whether the load balancer is internal or not"
  type        = bool
}

variable "Environment" {
  description = "Enter name of the ENV"
  type        = string
}

variable "target-gorup-protocol" {
  type        = string
  description = "protocol for target group"
}


variable "target-group-port" {
  type        = string
  description = "port for target group"
}

variable "listener-protocol" {
  type        = string
  description = "protocol type"
}

variable "listener-port" {
  type        = number
  description = "ports"
}

variable "lb_tags" {
  type = map(string)
}

variable "vpc_id" {
  type        = string
  description = "vpc id"
}

variable "private_subnet_ids" {
  type        = list(string)
  description = "subnet id"
}

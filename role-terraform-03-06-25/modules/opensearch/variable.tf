variable "domain_name" {
  type        = string
  description = "The name of the OpenSearch domain."
}

variable "opensearch_engine_version" {
  type        = string
  description = "The version of the OpenSearch engine to deploy."
}

variable "instance_type" {
  type        = string
  description = "The instance type for data nodes (e.g., r6g.large.search)."
}

variable "instance_count" {
  type        = number
  description = "The number of data nodes in the OpenSearch cluster."
}

variable "master_instance_type" {
  type        = string
  description = "The instance type for dedicated master nodes."
}

variable "master_instance_count" {
  type        = number
  description = "The number of dedicated master nodes."
}

variable "availability_zone_count" {
  type        = number
  description = "The number of Availability Zones for the domain."
}

variable "volume_size" {
  type        = number
  description = "The size of the EBS volume in GB."
}

variable "vpc_id" {
  type        = string
  description = "The ID of the VPC where the OpenSearch domain will be deployed."
}

variable "private_subnet1" {
  type        = string
  description = "List of subnet IDs to launch the domain in."
}

variable "vpc_cidr_block" {
  type        = string
  description = "List of CIDR blocks allowed to access the OpenSearch domain."
}

variable "region" {
  type        = string
  description = "The AWS region to deploy resources in."
}

variable "account_id" {
  type        = string
  description = "The AWS account ID used for configuring access policies."
}

variable "common_secret_name" {
  type        = string
  description = "Name of the AWS Secrets Manager secret containing OpenSearch credentials."
}

variable "opensearch_tags" {
  type        = map(string)
  description = "Enter tags for opensearch."
}

variable "Environment" {
  type        = string
  description = "Enter name of the Environment."
}

variable "customer_name" {
  type        = string
  description = "Name of the customer."
}
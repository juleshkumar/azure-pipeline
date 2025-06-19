variable "redis-cluster" {
  type        = string
  description = "The ID of the ElastiCache cluster"
}

variable "redis-engine" {
  type        = string
  description = "The name of the cache engine to be used for the clusters in this replication group"
}

variable "redis-engine-version" {
  type        = string
  description = "The version number of the cache engine to be used for the cache clusters in this replication group"
}

variable "redis-node-type" {
  type        = string
  description = "The compute and memory capacity of the nodes in the node group"
}

variable "num_cache_clusters" {
  description = "The number of node groups (shards) for this Redis replication group"
  type        = number
}

#variable "replicas-per-node-group" {
#  description = "The number of replica nodes in each node group (shard)"
#  type        = number
#}

variable "parameter-group-family" {
  description = "The initial number of cache nodes that the cache cluster has"
  type        = string
}

variable "replication-id" {
  type        = string
  description = "(optional) describe your variable"
}

variable "elasticache_tags" {
  type = map(string)
}

variable "redis-user-id" {
  type = string
}

variable "common_secret_name" {
  type = string
}


variable "redis_port" {
  type        = string
  description = "VRT CIDR Range"
}

variable "customer_name" {
  description = "Enter name of the customer"
  type        = string
}

variable "Environment" {
  type = string
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

variable "redis_rest_encryption" {
  type        = string
}

variable "cmk_arn" {
  type        = string
}

variable "redis_transit_encryption" {
  type        = string
}

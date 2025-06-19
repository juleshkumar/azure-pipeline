####COMMON########

variable "account_id" {
  description = "AWS Account ID"
  type        = string
}

variable "Environment" {
  type        = string
  description = "Environment"
}

variable "region" {
  type        = string
  description = "The AWS region to deploy resources in."
}

variable "common_secret_name" {
  type = string
}

variable "private_subnet1" {
  type        = string
  default = ""
}

variable "vpc_id" {
  type        = string
  default = ""
}

variable "vpc_cidr_block" {
  type        = string
  default = ""
}

variable "private_subnet_ids" {
  type        = list(string)
  default = []
}

variable "cmk_arn" {
  type        = string
  default = ""
}

variable "cluster-name" {
  description = "The name of the cluster"
  type        = string
}

variable "customer_name" {
  description = "Enter name of the customer"
  type        = string
}


####VPC#####

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "public_subnet_1_cidr" {
  description = "CIDR block for the first public subnet"
  type        = string
}

variable "private_subnet_1_cidr" {
  description = "CIDR block for the first private subnet"
  type        = string
}

variable "private_subnet_2_cidr" {
  description = "CIDR block for the second private subnet"
  type        = string
}

variable "vpc_tags" {
  description = "Tags for the VPC"
  type        = map(string)
}



############KMS############################################################

variable "kms_tags" {
  type = map(string)
  
}

####################ec2_linux################################################
variable "ami" {
  type        = string
  description = "The ID of the Amazon Machine Image (AMI) used to launch the instance"
}

variable "ec2_instance_type" {
  type        = string
  description = "The type of EC2 instance to launch"
}

variable "linux_tags" {
  type = map(string)
}

variable "ec2_linux_volume_size" {
  type        = number
  description = "Root EBS volume size in GiB"
}


####################EC2_MSSQL###################################
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

variable "ec2_mssql_volume_size" {
  type        = number
  description = "Root EBS volume size in GiB"
}

###################EKS-variable######################################
variable "k8s_version" {
  description = "Kubernetes version."
  type        = string
}

variable "eks_tags" {
  type = map(string)
}

##########################Nodegroups##########################

variable "cloudwatch_logs" {
  type        = bool
  description = "Setup full CloudWatch logging."
}

variable "ec2_root_volume_size" {
  type        = string
}

variable "eks_cluster_sg_id" {
  type        = string
  default = ""
}

variable "eks_cluster_id" {
  type        = string
  default = ""
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

#################EKS-ADDON####################################
variable "coredns_version" {
  description = "Version of the CoreDNS addon"
  type        = string
}

variable "kube_proxy_version" {
  description = "Version of the kube-proxy addon"
  type        = string
}

variable "pod_identity_agent_version" {
  description = "Version of the pod identity agent addon"
  type        = string
}

variable "s3_csi_driver_version" {
  description = "Version of the aws-mountpoint-s3-csi-driver addon"
  type        = string
}

variable "efs_csi_driver_version" {
  description = "Version of the aws-efs-csi-driver addon"
  type        = string
}

variable "vpc_cni_version" {
  description = "Version of the vpc-cni addon"
  type        = string
}

#######################RDS######################
variable "rds_db_instance_identifier" {
  type        = string
  description = "Please mention the Database Instance Identifier"
}

variable "rds_database_name" {
  type        = string
  description = "rds Database Name"
}

variable "major_version" {
  type        = string
  description = "rds Database Parameter Group Major Version"
}

variable "engine_version" {
  type        = string
  description = "rds Database Engine Version"
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

#######################MySQL RDS######################
variable "mysql_db_instance_identifier" {
  type        = string
  description = "Please mention the MySQL Database Instance Identifier"
}

variable "mysql_database_name" {
  type        = string
  description = "MySQL Database Name"
}

variable "mysql_major_version" {
  type        = string
  description = "MySQL Database Parameter Group Major Version"
}

variable "mysql_engine_version" {
  type        = string
  description = "MySQL Database Engine Version"
}

variable "mysql_db_instance_type" {
  type        = string
  description = "MySQL Database Instance Type"
}

variable "mysql_db_allocated_storage" {
  type        = string
  description = "MySQL Database Storage Size"
}

variable "mysql_port" {
  type        = string
  description = "MySQL Port Number"
  default     = "3306"
}

variable "mysql_tags" {
  type = map(string)
  description = "Tags for MySQL resources"
}

#######################MSSQL RDS######################
variable "mssql_db_instance_identifier" {
  type        = string
  description = "Please mention the MSSQL Database Instance Identifier"
}

variable "mssql_major_version" {
  type        = string
  description = "MSSQL Database Parameter Group Major Version"
}

variable "mssql_engine_version" {
  type        = string
  description = "MSSQL Database Engine Version"
}

variable "mssql_edition" {
  type        = string
  description = "MSSQL edition (ee, se, ex, web)"
}

variable "mssql_db_instance_type" {
  type        = string
  description = "MSSQL Database Instance Type"
}

variable "mssql_db_allocated_storage" {
  type        = string
  description = "MSSQL Database Storage Size"
}

variable "mssql_port" {
  type        = string
  description = "MSSQL Port Number"
  default     = "1433"
}

variable "mssql_multi_az" {
  type        = bool
  description = "Enable Multi-AZ deployment for MSSQL"
  default     = false
}

variable "mssql_backup_retention_period" {
  type        = number
  description = "Number of days to retain MSSQL backups"
  default     = 7
}

variable "mssql_backup_window" {
  type        = string
  description = "Preferred backup window for MSSQL"
  default     = "03:00-06:00"
}

variable "mssql_maintenance_window" {
  type        = string
  description = "Preferred maintenance window for MSSQL"
  default     = "sun:06:00-sun:10:00"
}

variable "mssql_timezone" {
  type        = string
  description = "Time zone of the MSSQL instance"
  default     = "Eastern Standard Time"
}

variable "mssql_character_set_name" {
  type        = string
  description = "Character set name for MSSQL"
  default     = "SQL_Latin1_General_CP1_CI_AS"
}

variable "mssql_backup_restore_role_arn" {
  type        = string
  description = "ARN of the IAM role for SQLSERVER_BACKUP_RESTORE option"
  default     = ""
}

variable "mssql_tags" {
  type = map(string)
  description = "Tags for MSSQL resources"
}

#########################REDIS#################################
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


variable "redis_port" {
  type        = string
  description = "VRT CIDR Range"
}

variable "redis_rest_encryption" {
  type        = string
}

variable "redis_transit_encryption" {
  type        = string
}


#########################ALB#################################

variable "internal" {
  description = "Whether the load balancer is internal or not"
  type        = bool
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


######################RabbitMQ########################

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

variable "console_access" {
  description = "Allow user console access"
  type        = bool
}

variable "user_groups" {
  description = "Groups to which the user belongs"
  type        = list(string)
}

variable "mq_tags" {
  description = "Tags to assign to resources"
  type        = map(string)
}

########################opensearch##########################
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

variable "opensearch_tags" {
  type        = map(string)
  description = "Enter tags for opensearch."
}


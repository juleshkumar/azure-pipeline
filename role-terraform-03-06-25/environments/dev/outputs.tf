#######vpc#########

output "vpc_id" {
  value = module.vpc.vpc_id
}

output "public_subnet_ids" {
  value = module.vpc.public_subnet_ids
}

output "private_subnet_ids" {
  value = module.vpc.private_subnet_ids
}

output "private_route_table_id" {
  value = module.vpc.private_route_table_id
}

output "igw_id" {
  value = module.vpc.igw_id
}

output "public_route_table_id" {
  value = module.vpc.public_route_table_id
}

output "security_group_id" {
  value = module.vpc.security_group_id
}

output "vpc_cidr_block" {
  value = module.vpc.vpc_cidr_block
}

output "nat_gateway_id" {
  value = module.vpc.nat_gateway_id
}

output "nat_gateway_public_ip" {
  value = module.vpc.nat_gateway_public_ip
}

############KMS#############
output "key_arn" {
  description = "The arn of the key"
  value       = module.kms.key_arn
}

output "key_id" {
  description = "The globally unique identifier for the key"
  value       = module.kms.key_id
}

output "key_alias_arn" {
  description = "The arn of the key alias"
  value       = module.kms.key_alias_arn
}

output "key_alias_name" {
  description = "The name of the key alias"
  value       = module.kms.key_alias_name
}

##########linux-EC2#########

output "private_ip" {
  description = "Private IP of instance"
  value       = module.ec2_linux.private_ip
}

output "private_dns" {
  description = "Private DNS of instance"
  value       = module.ec2_linux.private_dns
}

output "instance_id" {
  description = "ID of the instance"
  value       = module.ec2_linux.id
}

output "instance_arn" {
  description = "ARN of the instance"
  value       = module.ec2_linux.arn
}

output "instance_profile_name" {
  description = "Name of the IAM instance profile"
  value       = module.ec2_linux.iam_instance_profile_name
}

output "instance_security_group_id" {
  description = "ID of the instance security group"
  value       = module.ec2_linux.security_group_id
}

########MSSQL-EC2##############

output "mssql_private_ip" {
  description = "Private IP of instance"
  value       = module.ec2_mssql.private_ip
}

output "mssql_private_dns" {
  description = "Private DNS of instance"
  value       = module.ec2_mssql.private_dns
}

output "mssql_instance_id" {
  description = "ID of the instance"
  value       = module.ec2_mssql.id
}

output "mssql_instance_arn" {
  description = "ARN of the instance"
  value       = module.ec2_mssql.arn
}

output "mssql_instance_profile_name" {
  description = "Name of the IAM instance profile"
  value       = module.ec2_mssql.iam_instance_profile_name
}

output "mssql_instance_security_group_id" {
  description = "ID of the instance security group"
  value       = module.ec2_mssql.security_group_id
}

##########################EKS-variables############################################
output "eks_cluster_id" {
  description = "The name of the cluster"
  value       = module.eks.eks_cluster_id
}

output "eks_cluster_arn" {
  description = "The Amazon Resource Name (ARN) of the cluster"
  value       = module.eks.eks_cluster_arn
}

output "eks_cluster_endpoint" {
  description = "The endpoint for the Kubernetes API server"
  value       = module.eks.eks_cluster_endpoint
}

output "eks_cluster_version" {
  description = "The Kubernetes server version of the cluster"
  value       = module.eks.eks_cluster_version
}

output "eks_cluster_security_group_id" {
  description = "The ID of the additional EKS cluster security group"
  value       = module.eks.eks_cluster_security_group_id
}

output "eks_cluster_security_group_arn" {
  description = "The ARN of the additional EKS cluster security group"
  value       = module.eks.eks_cluster_security_group_arn
}

output "eks_cluster_certificate_authority" {
  description = "The Kubernetes cluster certificate authority data"
  value       = module.eks.eks_cluster_certificate_authority
}

output "eks_oidc_provider_arn" {
  description = "The ARN of the OIDC Provider"
  value       = module.eks.eks_oidc_provider_arn
}

output "eks_oidc_provider_url" {
  description = "The URL of the OIDC Provider"
  value       = module.eks.eks_oidc_provider_url
}

#################nodegroups######################
output "eks_node_role_arn" {
  description = "The ARN of the EKS node role"
  value       = module.nodegroup.eks_node_role_arn
}

#########RDS################
output "rds_endpoint" {
  value = module.postgres.rds_endpoint
}

output "rds_security_group_id" {
  value = module.postgres.rds_security_group_id
}

output "rds_subnet_group_name" {
  value = module.postgres.rds_subnet_group_name
}

output "rds_parameter_group_name" {
  value = module.postgres.rds_parameter_group_name
}

output "rds_database_identifier" {
  value = module.postgres.rds_database_identifier
}


#########MySQL RDS################
output "mysql_endpoint" {
  value = module.mysql.rds_endpoint
  description = "The connection endpoint for the MySQL RDS instance"
}

output "mysql_security_group_id" {
  value = module.mysql.rds_security_group_id
  description = "The security group ID of the MySQL RDS instance"
}

output "mysql_subnet_group_name" {
  value = module.mysql.rds_subnet_group_name
  description = "The subnet group name of the MySQL RDS instance"
}

output "mysql_parameter_group_name" {
  value = module.mysql.rds_parameter_group_name
  description = "The parameter group name of the MySQL RDS instance"
}

output "mysql_database_identifier" {
  value = module.mysql.rds_database_identifier
  description = "The identifier of the MySQL RDS instance"
}



#########MSSQL RDS################
output "mssql_endpoint" {
  value = module.mssql.rds_endpoint
}

output "mssql_security_group_id" {
  value = module.mssql.rds_security_group_id
}

output "mssql_subnet_group_name" {
  value = module.mssql.rds_subnet_group_name
}

output "mssql_option_group_name" {
  value = module.mssql.rds_option_group_name
}

output "mssql_database_identifier" {
  value = module.mssql.rds_database_identifier
}

#########elasticache#######################################################


output "redis_parameter_group_name" {
  value = module.elasticache.redis_parameter_group_name
}

output "elasticache_security_group_id" {
  value = module.elasticache.elasticache_security_group_id
}

output "elasticache_subnet_group_name" {
  value = module.elasticache.elasticache_subnet_group_name
}

output "elasticache_cluster_id" {
  value = module.elasticache.elasticache_cluster_id
}

output "redis_cluster_endpoint" {
  description = "The endpoint of the Redis cluster"
  value       = module.elasticache.redis_cluster_endpoint
}

output "redis_cluster_configuration_endpoint" {
  description = "The configuration endpoint of the Redis cluster"
  value       = module.elasticache.redis_cluster_configuration_endpoint
}

#######################ALB#######################################
output "load_balancer_dns_name" {
  description = "The DNS name of the load balancer"
  value       = module.load_balancer.load_balancer_dns_name
}

output "security_groups" {
  value = module.load_balancer.lb_security_group
}


output "lb_arn" {
  value = module.load_balancer.lb_arn
}

output "lb_target_arn" {
  value = module.load_balancer.lb_target_arn
}

##############RabbitMQ################
output "broker_id" {
  description = "ID of the RabbitMQ broker"
  value       = module.rabbit_mq.broker_id
}

output "broker_arn" {
  description = "ARN of the RabbitMQ broker"
  value       = module.rabbit_mq.broker_arn
}

output "broker_hostname" {
  description = "Hostname of the RabbitMQ broker"
  value       = module.rabbit_mq.broker_hostname
}


################opensearch########################
output "opensearch_endpoint" {
  description = "OpenSearch domain endpoint"
  value       = module.opensearch.opensearch_endpoint
}

output "opensearch_arn" {
  description = "OpenSearch domain ARN"
  value       = module.opensearch.opensearch_arn
}


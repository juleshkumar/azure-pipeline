output "redis_parameter_group_name" {
  value = aws_elasticache_parameter_group.redis_parameter_group.name
}

output "elasticache_security_group_id" {
  value = aws_security_group.elasticache_security_group.id
}

output "elasticache_subnet_group_name" {
  value = aws_elasticache_subnet_group.eccr.name
}

output "elasticache_cluster_id" {
  value = aws_elasticache_cluster.redis.id
}

output "redis_cluster_endpoint" {
  description = "The endpoint of the Redis cluster"
  value       = aws_elasticache_replication_group.erg.primary_endpoint_address
}

output "redis_cluster_configuration_endpoint" {
  description = "The configuration endpoint of the Redis cluster"
  value       = aws_elasticache_replication_group.erg.configuration_endpoint_address
}

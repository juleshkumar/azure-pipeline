data "aws_secretsmanager_secret" "combined" {
  name = "${var.common_secret_name}/credentials"
}

data "aws_secretsmanager_secret_version" "combined" {
  secret_id = data.aws_secretsmanager_secret.combined.id
}

locals {
  creds = jsondecode(data.aws_secretsmanager_secret_version.combined.secret_string)
}
resource "aws_elasticache_parameter_group" "redis_parameter_group" {
  name        = "${var.customer_name}-${var.Environment}-${var.redis-cluster}-parameter-group"
  family      = var.parameter-group-family
  description = "Custom parameter group for ElastiCache Redis"

}

resource "aws_security_group" "elasticache_security_group" {
  name        = "${var.customer_name}-${var.Environment}-${var.redis-cluster}-sg"
  description = "Security group for ElastiCache Redis cluster"
  vpc_id      = var.vpc_id

  # Ingress rule allowing access from specific subnets or security groups
  ingress {
    from_port   = var.redis_port
    to_port     = var.redis_port
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr_block]
  }

  # Egress rule allowing outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_elasticache_subnet_group" "eccr" {
  name       = "${var.customer_name}-${var.Environment}-${var.redis-cluster}-subnet-group"
  subnet_ids = var.private_subnet_ids
}

resource "aws_elasticache_user" "redis_user" {
  user_id   = "${var.Environment}-${var.redis-user-id}"
  user_name = local.creds.redis_username 
  engine    = var.redis-engine
  passwords = [local.creds.redis_password]  
  access_string = "on ~* +@all"  # Adjust access string as needed

  tags = {
    Name = "var.redis-user-id"
    Environment = var.Environment
  }
}

resource "aws_elasticache_user_group" "redis_user_group" {
  user_group_id = "${var.Environment}-usergroup"
  engine        = var.redis-engine
  user_ids      = [aws_elasticache_user.redis_user.user_id]

  tags = {
    Environment = var.Environment
  }
}

locals {
  constant_oss_cluster_tags = {
    Environment = var.Environment
    ManagedBy   = "Terraform"
  }
}

resource "aws_elasticache_replication_group" "erg" {
  replication_group_id          = var.replication-id
  description                   = "Single-node Redis"
  engine                        = var.redis-engine
  engine_version                = var.redis-engine-version
  node_type                     = var.redis-node-type
  num_cache_clusters            = var.num_cache_clusters
  automatic_failover_enabled    = false
  at_rest_encryption_enabled    = var.redis_rest_encryption
  transit_encryption_enabled    = var.redis_transit_encryption
  kms_key_id                    = var.cmk_arn
  port                          = var.redis_port
  auto_minor_version_upgrade    = false
  subnet_group_name             = aws_elasticache_subnet_group.eccr.name
  security_group_ids            = [aws_security_group.elasticache_security_group.id]
  parameter_group_name          = aws_elasticache_parameter_group.redis_parameter_group.name
  user_group_ids                = [aws_elasticache_user_group.redis_user_group.user_group_id]
  snapshot_window               = "03:00-04:00"  
  snapshot_retention_limit      = 14

  tags = merge(
    local.constant_oss_cluster_tags,
    var.elasticache_tags
  )
}

resource "aws_elasticache_cluster" "redis" {
  cluster_id           = var.redis-cluster
  replication_group_id = aws_elasticache_replication_group.erg.id
}

module "vpc" {
  source                     = "../../modules/vpc"
  vpc_cidr                   = var.vpc_cidr
  public_subnet_1_cidr       = var.public_subnet_1_cidr
  private_subnet_1_cidr      = var.private_subnet_1_cidr
  private_subnet_2_cidr      = var.private_subnet_2_cidr
  vpc_tags                   = var.vpc_tags
  cluster-name               = var.cluster-name
  Environment                = var.Environment
  customer_name              = var.customer_name
}

module "kms" {
  source                      = "../../modules/kms"
  kms_tags                    = var.kms_tags
  account_id                  = var.account_id
  Environment                 = var.Environment
  customer_name               = var.customer_name
}

module "ec2_linux" {
  source                      = "../../modules/ec2_linux"
  ami                         = var.ami
  ec2_instance_type           = var.ec2_instance_type
  Environment                 = var.Environment
  ec2_linux_volume_size       = var.ec2_linux_volume_size
  customer_name               = var.customer_name
  linux_tags                  = var.linux_tags
  vpc_id                      = module.vpc.vpc_id
  private_subnet1             = module.vpc.private_subnet_ids[0]
  vpc_cidr_block              = module.vpc.vpc_cidr_block
  cmk_arn                     = module.kms.key_arn
  depends_on                  = [module.vpc,module.kms]
}

module "ec2_mssql" {
  source                      = "../../modules/ec2_mssql"
  mssql_ami                   = var.mssql_ami
  mssql_ec2_instance_type     = var.mssql_ec2_instance_type
  ec2_mssql_tags              = var.ec2_mssql_tags
  Environment                 = var.Environment
  customer_name               = var.customer_name
  ec2_mssql_volume_size       = var.ec2_mssql_volume_size
  vpc_id                      = module.vpc.vpc_id
  private_subnet1             = module.vpc.private_subnet_ids[0]
  vpc_cidr_block              = module.vpc.vpc_cidr_block
  cmk_arn                     = module.kms.key_arn
  depends_on                  = [module.vpc,module.kms]
}

module "eks" {
  source                      = "../../modules/eks"
  customer_name               = var.customer_name
  Environment                 = var.Environment
  cluster-name                = var.cluster-name
  k8s_version                 = var.k8s_version
  eks_tags                    = var.eks_tags
  vpc_cidr_block              = module.vpc.vpc_cidr_block
  private_subnet_ids          = module.vpc.private_subnet_ids
  vpc_id                      = module.vpc.vpc_id
  cmk_arn                     = module.kms.key_arn
  depends_on                  = [module.vpc,module.kms]
}

module "nodegroup" {
  source                      = "../../modules/nodegroup"
  cloudwatch_logs             = var.cloudwatch_logs
  cluster-name                = var.cluster-name
  Environment                 = var.Environment
  customer_name               = var.customer_name
  ec2_root_volume_size        = var.ec2_root_volume_size
  k8s_version                 = var.k8s_version
  node_groups_test            = var.node_groups_test
  node_groups_test_tt         = var.node_groups_test_tt
  eks_cluster_id              = module.eks.eks_cluster_id
  eks_cluster_sg_id           = module.eks.eks_cluster_security_group_id
  vpc_cidr_block              = module.vpc.vpc_cidr_block
  private_subnet_ids          = module.vpc.private_subnet_ids
  vpc_id                      = module.vpc.vpc_id
  cmk_arn                     = module.kms.key_arn
  depends_on                  = [module.vpc,module.eks]
}

module "eks-addon" {
  source                      = "../../modules/eks-addon"
  cluster-name                = var.cluster-name
  coredns_version             = var.coredns_version
  kube_proxy_version          = var.kube_proxy_version
  pod_identity_agent_version  = var.pod_identity_agent_version
  s3_csi_driver_version       = var.s3_csi_driver_version
  efs_csi_driver_version      = var.efs_csi_driver_version
  vpc_cni_version             = var.vpc_cni_version
  depends_on                  = [module.eks,module.nodegroup]
}


module "postgres" {
  source                      = "../../modules/psql"
  major_version               = var.major_version
  engine_version              = var.engine_version
  rds_database_name           = var.rds_database_name
  rds_db_allocated_storage    = var.rds_db_allocated_storage
  rds_db_instance_identifier  = var.rds_db_instance_identifier
  rds_db_instance_type        = var.rds_db_instance_type
  common_secret_name          = var.common_secret_name
  rds_tags                    = var.rds_tags
  rds_port                    = var.rds_port
  Environment                 = var.Environment
  customer_name               = var.customer_name
  vpc_cidr_block              = module.vpc.vpc_cidr_block
  private_subnet_ids          = module.vpc.private_subnet_ids
  vpc_id                      = module.vpc.vpc_id
  cmk_arn                     = module.kms.key_arn
  depends_on                  = [module.vpc,module.kms]
}

module "mysql" {
  source                      = "../../modules/mysql"
  rds_db_instance_identifier  = var.mysql_db_instance_identifier
  rds_database_name           = var.mysql_database_name
  common_secret_name          = var.common_secret_name
  major_version               = var.mysql_major_version
  engine_version              = var.mysql_engine_version
  customer_name               = var.customer_name
  rds_db_instance_type        = var.mysql_db_instance_type
  rds_db_allocated_storage    = var.mysql_db_allocated_storage
  rds_port                    = var.mysql_port
  vpc_cidr_block              = module.vpc.vpc_cidr_block
  private_subnet_ids          = module.vpc.private_subnet_ids
  vpc_id                      = module.vpc.vpc_id
  Environment                 = var.Environment
  rds_tags                    = var.mysql_tags
  cmk_arn                     = module.kms.key_arn
  depends_on                  = [module.vpc,module.kms]
}

module "mssql" {
  source                      = "../../modules/mssql"
  rds_db_instance_identifier  = var.mssql_db_instance_identifier
  common_secret_name          = var.common_secret_name
  major_version               = var.mssql_major_version
  engine_version              = var.mssql_engine_version
  edition                     = var.mssql_edition
  customer_name               = var.customer_name
  rds_db_instance_type        = var.mssql_db_instance_type
  rds_db_allocated_storage    = var.mssql_db_allocated_storage
  rds_port                    = var.mssql_port
  Environment                 = var.Environment
  multi_az                    = var.mssql_multi_az
  backup_retention_period     = var.mssql_backup_retention_period
  backup_window               = var.mssql_backup_window
  maintenance_window          = var.mssql_maintenance_window
  timezone                    = var.mssql_timezone
  character_set_name          = var.mssql_character_set_name
  backup_restore_role_arn     = var.mssql_backup_restore_role_arn
  rds_tags                    = var.mssql_tags
  vpc_cidr_block              = module.vpc.vpc_cidr_block
  private_subnet_ids          = module.vpc.private_subnet_ids
  vpc_id                      = module.vpc.vpc_id
  cmk_arn                     = module.kms.key_arn
  depends_on                  = [module.vpc,module.kms]
}

module "elasticache" {
  source                      = "../../modules/elasticache"
  redis-cluster               = var.redis-cluster
  redis-engine                = var.redis-engine
  redis-engine-version        = var.redis-engine-version
  redis-node-type             = var.redis-node-type
  parameter-group-family      = var.parameter-group-family
  replication-id              = var.replication-id
  num_cache_clusters          = var.num_cache_clusters
  #replicas-per-node-group    = var.replicas-per-node-group
  elasticache_tags            = var.elasticache_tags
  redis-user-id               = var.redis-user-id
  redis_port                  = var.redis_port
  common_secret_name          = var.common_secret_name
  redis_rest_encryption       = var.redis_rest_encryption
  redis_transit_encryption    = var.redis_transit_encryption
  Environment                 = var.Environment
  customer_name               = var.customer_name
  vpc_cidr_block              = module.vpc.vpc_cidr_block
  private_subnet_ids          = module.vpc.private_subnet_ids
  vpc_id                      = module.vpc.vpc_id
  cmk_arn                     = module.kms.key_arn
  depends_on                  = [module.vpc,module.kms]
}

module "load_balancer" {
  source                      = "../../modules/load_balancer"
  internal                    = var.internal
  listener-protocol           = var.listener-protocol
  listener-port               = var.listener-port
  target-group-port           = var.target-group-port
  target-gorup-protocol       = var.target-gorup-protocol
  Environment                 = var.Environment
  customer_name               = var.customer_name
  lb_tags                     = var.lb_tags
  private_subnet_ids          = module.vpc.private_subnet_ids
  vpc_id                      = module.vpc.vpc_id
  depends_on                  = [module.vpc]
}

module "rabbit_mq" {
  source                      = "../../modules/rabbit_mq"
  mq_engine_version           = var.mq_engine_version
  host_instance_type          = var.host_instance_type
  deployment_mode             = var.deployment_mode
  publicly_accessible         = var.publicly_accessible
  auto_minor_version_upgrade  = var.auto_minor_version_upgrade
  apply_immediately           = var.apply_immediately
  common_secret_name          = var.common_secret_name
  console_access              = var.console_access
  user_groups                 = var.user_groups
  maintenance_day             = var.maintenance_day
  maintenance_time            = var.maintenance_time
  maintenance_timezone        = var.maintenance_timezone
  logs_general                = var.logs_general
  mq_tags                     = var.mq_tags
  Environment                 = var.Environment
  customer_name               = var.customer_name
  vpc_id                      = module.vpc.vpc_id
  private_subnet1             = module.vpc.private_subnet_ids[0]
  vpc_cidr_block              = module.vpc.vpc_cidr_block
  depends_on                  = [module.vpc]
}

module "opensearch" {
  source                      = "../../modules/opensearch"
  domain_name                 = var.domain_name
  opensearch_engine_version   = var.opensearch_engine_version
  instance_type               = var.instance_type
  instance_count              = var.instance_count
  master_instance_type        = var.master_instance_type
  master_instance_count       = var.master_instance_count
  availability_zone_count     = var.availability_zone_count
  volume_size                 = var.volume_size
  region                      = var.region
  account_id                  = var.account_id
  common_secret_name          = var.common_secret_name
  opensearch_tags             = var.opensearch_tags
  Environment                 = var.Environment
  customer_name               = var.customer_name
  vpc_id                      = module.vpc.vpc_id
  private_subnet1             = module.vpc.private_subnet_ids[0]
  vpc_cidr_block              = module.vpc.vpc_cidr_block
  depends_on                  = [module.vpc]
}
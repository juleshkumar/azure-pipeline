account_id                   = "296062546708"
Environment                  = "prod"
customer_name                = "uipl-demo"
region                       = "us-east-1"
common_secret_name           = "dev"
#vpc_id                       = "vpc-00634cff446eb355e"
#vpc_cidr_block               = "10.0.0.0/16"
#private_subnet1              = "subnet-0815b57a12921e003"
#private_subnet_ids           = ["subnet-0815b57a12921e003", "subnet-02418f36113e78a24"]


####VPC variables################################################
vpc_cidr                    = "10.1.0.0/16"
public_subnet_1_cidr        = "10.1.1.0/24"
private_subnet_1_cidr       = "10.1.2.0/24"
private_subnet_2_cidr       = "10.1.3.0/24"
vpc_tags                    = {map-migrated: "mig3JL1ESW2OI"}

#############KMS###########################################
kms_tags                     = {map-migrated: "mig3JL1ESW2OI"}

#######EC2-Linux vairbales###################################

ami                          = "ami-07a6f770277670015"
ec2_instance_type            = "t2.micro"
ec2_linux_volume_size        = 10
linux_tags                   = {map-migrated: "mig3JL1ESW2OI"}


###############EC2-MSSQL variables###########################

mssql_ami                    = "ami-0ee0763aa195c298f"
mssql_ec2_instance_type      = "r5.xlarge"
ec2_mssql_volume_size        = 75
ec2_mssql_tags               = {map-migrated: "mig3JL1ESW2OI"}

#####################EKS-vairbales##################################

k8s_version                  = "1.31"
cluster-name                 =  "test-prod-eks-cluster"
eks_tags                     = {map-migrated: "mig3JL1ESW2OI"}

###############Nodegroups vairbales###################

cloudwatch_logs = false
ec2_root_volume_size = "20"
node_groups_test = [
  {
    name           = "nginx-prod-ondemand-new"
    instance_types = ["t3.medium"]
    ng_test_tags = {
      map-migrated: "mig3JL1ESW2OI"
    }
    labels = {
      vrt-cug-nginx = "true"
    }
    tolerations = {
      key    = "key"
      value  = "persistTool"
      effect = "NO_SCHEDULE"
    }
    minimum_size   = 1
    maximum_size   = 2
    desired_size   = 1
    capacity_type  = "ON_DEMAND"
  }
]

node_groups_test_tt = [
  {
    name           = "application-prod-nodegroup-ondemand-new"
    instance_types = ["m6i.large", "t3.medium", "r6i.large"]
    ng_test_tags = {
      map-migrated: "mig3JL1ESW2OI"
    }
    labels = {
      prod = "true"
    }
    minimum_size   = 2
    maximum_size   = 6
    desired_size   = 2
    capacity_type  = "ON_DEMAND"
  }
]


###############EKS-ADDON##############################
coredns_version              = "v1.11.4-eksbuild.2"
kube_proxy_version           = "v1.31.2-eksbuild.3"
pod_identity_agent_version   = "v1.3.4-eksbuild.1"
s3_csi_driver_version        = "v1.14.1-eksbuild.1"
efs_csi_driver_version       = "v2.1.6-eksbuild.1"
vpc_cni_version              = "v1.19.2-eksbuild.1"

###############RDS########################

rds_db_instance_identifier   = "test-prod-db-tech"
rds_database_name            = "test_prod_database"
major_version                = "12"
engine_version               = "12.22"
rds_db_instance_type         = "db.m6g.large"
rds_db_allocated_storage     = "20"
rds_port                     = 5432
rds_tags                     = {map-migrated: "mig3JL1ESW2OI"}

###############MySQL RDS########################
mysql_db_instance_identifier = "test-prod-mysql"
mysql_database_name          = "test_prod_mysql_database"
mysql_major_version          = "8.0"
mysql_engine_version         = "8.0.35"
mysql_db_instance_type       = "db.t3.medium"
mysql_db_allocated_storage   = "20"
mysql_port                   = "3306"
mysql_tags                   = {map-migrated: "mig3JL1ESW2OI"}


###############MSSQL RDS########################
mssql_db_instance_identifier = "test-prod-mssql"
mssql_major_version          = "15.00"
mssql_engine_version         = "15.00.4236.7.v1"
mssql_edition                = "se"  # Standard Edition
mssql_db_instance_type       = "db.m5.large"
mssql_db_allocated_storage   = "100"
mssql_port                   = "1433"
mssql_multi_az               = false
mssql_backup_retention_period = 7
mssql_backup_window          = "03:00-06:00"
mssql_maintenance_window     = "sun:06:00-sun:10:00"
mssql_timezone               = "Eastern Standard Time"
mssql_character_set_name     = "SQL_Latin1_General_CP1_CI_AS"
mssql_backup_restore_role_arn = ""  # Leave empty if not using backup/restore
mssql_tags                   = {map-migrated: "mig3JL1ESW2OI"}


#########################redis_variables######################

redis-cluster                = "prod-elasticache-cluster"
redis-engine                 = "REDIS"
redis-engine-version         = "7.0"
redis-node-type              = "cache.t3.small"
num_cache_clusters           = "1"
#replicas-per-node-group     = "0"
parameter-group-family       = "redis7"
replication-id               = "test-prod-elasticache-replication"
redis-user-id                = "redis-user"
redis_port                   = 6379
redis_transit_encryption     = true
redis_rest_encryption        = true
elasticache_tags             = {map-migrated: "mig3JL1ESW2OI"}

#########################ALB variables####################################

load_balancer_name           = "test-ALB"
internal                     = true
load_balancer_type           = "application"
lb_security_group            = "prpd-load-balancer-sg"
target-group-name            = "tg-prod-sg-lb"
target-group-port            = 443
target-gorup-protocol        = "HTTPS"
listener-protocol            = "HTTP"
listener-port                = 80
lb_tags                      = {map-migrated: "mig3JL1ESW2OI"}

###############RabbitMQ################

mq_engine_version            = "3.13"               
host_instance_type           = "mq.t3.micro"
deployment_mode              = "SINGLE_INSTANCE"
publicly_accessible          = false
auto_minor_version_upgrade   = true
apply_immediately            = true
console_access               = true
user_groups                  = ["admins"]
maintenance_day              = "WEDNESDAY"
maintenance_time             = "02:00"
maintenance_timezone         = "UTC"
logs_general                 = true
mq_tags                      = {map-migrated: "mig3JL1ESW2OI"}


#################opensearch###############
domain_name                  = "demo-prod-opensearch"
opensearch_engine_version    = "OpenSearch_2.11"
instance_type                = "t3.medium.search"
instance_count               = 2
master_instance_type         = "t3.small.search"
master_instance_count        = 3
availability_zone_count      = 1
volume_size                  = 20
opensearch_tags              = {map-migrated: "mig3JL1ESW2OI"}




















































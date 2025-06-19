data "aws_secretsmanager_secret" "combined" {
  name = "${var.common_secret_name}/credentials"
}

data "aws_secretsmanager_secret_version" "combined" {
  secret_id = data.aws_secretsmanager_secret.combined.id
}

locals {
  creds = jsondecode(data.aws_secretsmanager_secret_version.combined.secret_string)
}

resource "aws_db_subnet_group" "rds_subnet_group" {
  name        = "${var.customer_name}-${var.Environment}-${var.rds_db_instance_identifier}-subnet-group"
  description = "RDS subnet group"
  subnet_ids  = var.private_subnet_ids
}

resource "aws_security_group" "rds_security" {
  name        = "${var.customer_name}-${var.Environment}-${var.rds_db_instance_identifier}-sg"
  description = "RDS MySQL server"
  vpc_id      = var.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "${var.customer_name}-${var.Environment}-${var.rds_db_instance_identifier}-sg",
    Environment = var.Environment
  }
}

resource "aws_security_group_rule" "rds_ingress_rules" {
  type              = "ingress"
  from_port         = var.rds_port
  to_port           = var.rds_port
  protocol          = "tcp"
  cidr_blocks       = [var.vpc_cidr_block]
  security_group_id = aws_security_group.rds_security.id
}

resource "aws_db_parameter_group" "rds_database" {
  name        = "${var.customer_name}-${var.Environment}-${var.rds_db_instance_identifier}-param-group"
  description = "RDS parameter group for MySQL"
  family      = "mysql${var.major_version}"
  
  parameter {
    name  = "event_scheduler"
    value = "ON"
    apply_method = "pending-reboot"
  }
  
  parameter {
    name  = "general_log"
    value = "1"
    apply_method = "pending-reboot"
  }
  
  parameter {
    name  = "log_bin_trust_function_creators"
    value = "1"
    apply_method = "pending-reboot"
  }
  
  parameter {
    name  = "lower_case_table_names"
    value = "1"
    apply_method = "pending-reboot"
  }
  
  parameter {
    name  = "max_allowed_packet"
    value = "536870912"
    apply_method = "pending-reboot"
  }
  
  parameter {
    name  = "max_connections"
    value = "1200"
    apply_method = "pending-reboot"
  }
  
  parameter {
    name  = "slow_query_log"
    value = "1"
    apply_method = "pending-reboot"
  }
  
  parameter {
    name  = "sql_mode"
    value = "STRICT_TRANS_TABLES,NO_ZERO_DATE,NO_ZERO_IN_DATE,NO_ENGINE_SUBSTITUTION,ERROR_FOR_DIVISION_BY_ZERO,ONLY_FULL_GROUP_BY"
    apply_method = "pending-reboot"
  }
  
  parameter {
    name  = "time_zone"
    value = "US/Eastern"
    apply_method = "pending-reboot"
  }
  
  parameter {
    name  = "tls_version"
    value = "TLSv1.2"
    apply_method = "pending-reboot"
  }
  
  tags = {
    Name = "${var.rds_database_name}-parameter-group"
  }
}

locals {
  constant_rds_tags = {
    Environment = var.Environment
    ManagedBy   = "Terraform"
  }
}

resource "aws_db_instance" "rds_database_instance" {
  identifier                = var.rds_db_instance_identifier
  allocated_storage         = var.rds_db_allocated_storage
  engine                    = "mysql"
  engine_version            = var.engine_version
  instance_class            = var.rds_db_instance_type
  db_name                   = var.rds_database_name
  username                  = local.creds.mysql_username
  password                  = local.creds.mysql_password
  db_subnet_group_name      = aws_db_subnet_group.rds_subnet_group.name
  storage_encrypted         = true
  vpc_security_group_ids    = [aws_security_group.rds_security.id]
  storage_type              = "gp2"
  skip_final_snapshot       = true
  final_snapshot_identifier = "Ignore"
  parameter_group_name      = aws_db_parameter_group.rds_database.name
  apply_immediately         = true
  deletion_protection           = true                 
  performance_insights_enabled  = true
  auto_minor_version_upgrade    = false
  port                      = var.rds_port
  kms_key_id                = var.cmk_arn
  tags = merge(
    local.constant_rds_tags,
    var.rds_tags
  )
}
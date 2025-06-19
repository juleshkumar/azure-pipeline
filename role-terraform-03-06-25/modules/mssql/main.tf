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
  description = "RDS MSSQL server"
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

# Using default parameter group

resource "aws_db_option_group" "mssql_options" {
  name                     = "${var.customer_name}-${var.Environment}-${var.rds_db_instance_identifier}-option-group"
  option_group_description = "Option group for MSSQL RDS"
  engine_name              = "sqlserver-${var.edition}"
  major_engine_version     = var.major_version
  
  # No options added by default
  
  tags = {
    Name = "${var.rds_db_instance_identifier}-option-group"
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
  engine                    = "sqlserver-${var.edition}"
  engine_version            = var.engine_version
  license_model             = "license-included"
  instance_class            = var.rds_db_instance_type
  username                  = local.creds.mssql_username
  password                  = local.creds.mssql_password
  db_subnet_group_name      = aws_db_subnet_group.rds_subnet_group.name
  storage_encrypted         = true
  vpc_security_group_ids    = [aws_security_group.rds_security.id]
  storage_type              = "gp3"
  skip_final_snapshot       = true
  final_snapshot_identifier = "Ignore"
  # Using default parameter group
  option_group_name         = aws_db_option_group.mssql_options.name
  apply_immediately         = true
  port                      = var.rds_port
  kms_key_id                = var.cmk_arn
  multi_az                  = var.multi_az
  backup_retention_period   = var.backup_retention_period
  backup_window             = var.backup_window
  maintenance_window        = var.maintenance_window
  timezone                  = var.timezone
  character_set_name        = var.character_set_name
  deletion_protection           = true                 
  performance_insights_enabled  = true
  auto_minor_version_upgrade    = false
  tags = merge(
    local.constant_rds_tags,
    var.rds_tags
  )
}
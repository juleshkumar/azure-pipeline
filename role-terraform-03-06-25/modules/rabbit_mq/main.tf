data "aws_secretsmanager_secret" "combined" {
  name = "${var.common_secret_name}/credentials"
}

data "aws_secretsmanager_secret_version" "combined" {
  secret_id = data.aws_secretsmanager_secret.combined.id
}

locals {
  creds = jsondecode(data.aws_secretsmanager_secret_version.combined.secret_string)
}

resource "aws_security_group" "mq_sg" {
  name        = "${var.customer_name}-${var.Environment}-rabbitmq-sg"
  description = "${var.customer_name}-${var.Environment}-rabbitmq-sg"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 5671
    to_port     = 5671
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr_block]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

locals {
  constant_rabbitmq_tags = {
    Environment = var.Environment
    ManagedBy   = "Terraform"
  }
}

resource "aws_mq_broker" "rabbitmq_broker" {
  broker_name           = "${var.customer_name}-${var.Environment}-rabbitmq"
  engine_type           = "RabbitMQ"
  engine_version        = var.mq_engine_version
  host_instance_type    = var.host_instance_type
  deployment_mode       = var.deployment_mode
  publicly_accessible   = var.publicly_accessible
  auto_minor_version_upgrade = var.auto_minor_version_upgrade
  apply_immediately     = var.apply_immediately
  storage_type          = "ebs"
  subnet_ids            = [var.private_subnet1]
  security_groups       = [aws_security_group.mq_sg.id]
  logs {
    general = var.logs_general
  }
  maintenance_window_start_time {
    day_of_week = var.maintenance_day
    time_of_day = var.maintenance_time
    time_zone   = var.maintenance_timezone
  }

  user {
    username = local.creds.rabbitmq_username
    password = local.creds.rabbitmq_password
    console_access = var.console_access
    groups   = var.user_groups
  }
  
  tags = merge(
    local.constant_rabbitmq_tags,
    var.mq_tags
  )
}

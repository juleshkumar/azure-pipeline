data "aws_secretsmanager_secret" "combined" {
  name = "${var.common_secret_name}/credentials"
}

data "aws_secretsmanager_secret_version" "combined" {
  secret_id = data.aws_secretsmanager_secret.combined.id
}

locals {
  creds = jsondecode(data.aws_secretsmanager_secret_version.combined.secret_string)
}

resource "aws_cloudwatch_log_resource_policy" "opensearch_logs" {
  policy_name = "${var.customer_name}-${var.Environment}-OpenSearchLogPolicy"

  policy_document = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "es.amazonaws.com"
        }
        Action = [
          "logs:PutLogEvents",
          "logs:CreateLogStream"
        ]
        Resource = "arn:aws:logs:${var.region}:${var.account_id}:log-group:/aws/opensearch/${var.customer_name}-${var.Environment}-${var.domain_name}/*"
      }
    ]
  })
}


resource "aws_security_group" "opensearch_sg" {
  name        = "${var.customer_name}-${var.Environment}-opensearch-access"
  description = "Allow HTTPS access to OpenSearch"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 443
    to_port     = 443
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

resource "aws_cloudwatch_log_group" "app_logs" {
  name              = "/aws/opensearch/${var.customer_name}-${var.Environment}-${var.domain_name}/application-logs"
  retention_in_days = 14
}

resource "aws_cloudwatch_log_group" "search_slow_logs" {
  name              = "/aws/opensearch/${var.customer_name}-${var.Environment}-${var.domain_name}/search-slow-logs"
  retention_in_days = 7
}


resource "aws_cloudwatch_log_group" "index_slow_logs" {
  name              = "/aws/opensearch/${var.customer_name}-${var.Environment}-${var.domain_name}/index-slow-logs"
  retention_in_days = 14
}
locals {
  constant_opensearch_cluster_tags = {
    Environment = var.Environment
    ManagedBy   = "Terraform"
  }
}
resource "aws_opensearch_domain" "main" {
  domain_name    = var.domain_name
  engine_version = var.opensearch_engine_version
  tags = merge(
    local.constant_opensearch_cluster_tags,
    var.opensearch_tags
  )

  cluster_config {
    instance_type             = var.instance_type
    instance_count            = var.instance_count
    dedicated_master_enabled  = var.master_instance_count != 0
    dedicated_master_type     = var.master_instance_type
    dedicated_master_count    = var.master_instance_count
    zone_awareness_enabled    = var.availability_zone_count != 1
    

    dynamic "zone_awareness_config" {
      for_each = var.availability_zone_count != 1 ? [1] : []
      content {
        availability_zone_count = var.availability_zone_count
      }
    }
  }

  ebs_options {
    ebs_enabled = true
    volume_size = var.volume_size
    volume_type = "gp3"
  }

  vpc_options {
    subnet_ids         = [var.private_subnet1]
    security_group_ids = [aws_security_group.opensearch_sg.id]
  }

  access_policies = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect    = "Allow",
      Principal = "*",
      Action    = "es:*",
      Resource  = "arn:aws:es:${var.region}:${var.account_id}:domain/${var.domain_name}/*"
    }]
  })

  encrypt_at_rest {
    enabled = true
  }

  node_to_node_encryption {
    enabled = true
  }

  advanced_security_options {
    enabled                        = true
    internal_user_database_enabled = true

    master_user_options {
      master_user_name     = local.creds.opensearch_username
      master_user_password = local.creds.opensearch_password
    }
  }

  snapshot_options {
    automated_snapshot_start_hour = 3
  }

  domain_endpoint_options {
    enforce_https       = true
    tls_security_policy = "Policy-Min-TLS-1-2-2019-07"
  }

  log_publishing_options {
    enabled                   = true
    log_type                  = "ES_APPLICATION_LOGS"
    cloudwatch_log_group_arn = aws_cloudwatch_log_group.app_logs.arn
  }

  log_publishing_options {
    cloudwatch_log_group_arn = aws_cloudwatch_log_group.search_slow_logs.arn
    log_type                 = "SEARCH_SLOW_LOGS"
    enabled                  = true
  }


  log_publishing_options {
    enabled                   = true
    log_type                  = "INDEX_SLOW_LOGS"
    cloudwatch_log_group_arn = aws_cloudwatch_log_group.index_slow_logs.arn
  }
}

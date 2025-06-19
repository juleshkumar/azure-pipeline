locals {
  constant_mssql_instance_tags = {
    Name        = "${var.customer_name}-${var.Environment}-ec2-mssql"
    Environment = var.Environment
    ManagedBy   = "Terraform"
  }
}
# IAM Role for EC2 with SSM access
resource "aws_iam_role" "ec2_mssql_ssm_role" {
  name               = "ec2-mssql-ssm-role-${var.Environment}-ec2mssql"
  description        = "IAM role for EC2 instances with SSM access"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
  tags = {
    Name = "EC2-SSM-Role"
  }
}

resource "aws_iam_instance_profile" "ec2_ssm_instance_profile" {
  name = "ec2-ssm-instance-profile-${var.Environment}-ec2mssql"
  role = aws_iam_role.ec2_mssql_ssm_role.name
}

resource "aws_iam_role_policy_attachment" "ssm_full_access" {
  role       = aws_iam_role.ec2_mssql_ssm_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMFullAccess"
}

resource "aws_security_group" "securitygroup" {
  name        = "${var.customer_name}-${var.Environment}-ec2mssql-sg"
  description = "Default SG to allow traffic from the VPC mysg"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 3389 # RDP port
    to_port     = 3389
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

resource "tls_private_key" "ec2mssql_private_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "ec2mssql_key" {
  key_name   = "${var.customer_name}-${var.Environment}-ec2mssql-keypair"
  public_key = tls_private_key.ec2mssql_private_key.public_key_openssh
}

resource "aws_ssm_parameter" "ec2mssql_private_key_ssm" {
  name        = "/${var.Environment}/ec2-keypairs/${var.customer_name}-${var.Environment}-ec2mssql-keypair"
  type        = "SecureString"
  value       = tls_private_key.ec2mssql_private_key.private_key_pem
  description = "Private key for ${var.customer_name}-${var.Environment}-ec2mssql-keypair"
  overwrite   = true

  tags = {
    Environment = var.Environment
    Customer    = var.customer_name
  }
}

resource "aws_instance" "master" {
  ami                         = var.mssql_ami
  instance_type               = var.mssql_ec2_instance_type
  key_name                    = aws_key_pair.ec2mssql_key.key_name
  subnet_id                   = var.private_subnet1
  vpc_security_group_ids      = [aws_security_group.securitygroup.id]
  iam_instance_profile        = aws_iam_instance_profile.ec2_ssm_instance_profile.name
  associate_public_ip_address = false

  root_block_device {
    volume_type = "gp3"
    volume_size = var.ec2_mssql_volume_size
    iops        = 3000
    throughput  = 125
    encrypted   = true
    kms_key_id  = var.cmk_arn
  }
  tags = merge(
    local.constant_mssql_instance_tags,
    var.ec2_mssql_tags
  )
  
  lifecycle {
    create_before_destroy = true
  }
}
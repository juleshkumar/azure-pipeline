output "rds_endpoint" {
  value = aws_db_instance.rds_database_instance.endpoint
  description = "The connection endpoint for the MSSQL RDS instance"
}

output "rds_security_group_id" {
  value = aws_security_group.rds_security.id
  description = "The security group ID of the MSSQL RDS instance"
}

output "rds_subnet_group_name" {
  value = aws_db_subnet_group.rds_subnet_group.name
  description = "The subnet group name of the MSSQL RDS instance"
}

output "rds_parameter_group_name" {
  value = aws_db_instance.rds_database_instance.parameter_group_name
  description = "The parameter group name of the MSSQL RDS instance (default)"
}

output "rds_option_group_name" {
  value = aws_db_option_group.mssql_options.name
  description = "The option group name of the MSSQL RDS instance"
}

output "rds_database_identifier" {
  value = aws_db_instance.rds_database_instance.identifier
  description = "The identifier of the MSSQL RDS instance"
}

output "rds_resource_id" {
  value = aws_db_instance.rds_database_instance.resource_id
  description = "The resource ID of the MSSQL RDS instance"
}

output "rds_arn" {
  value = aws_db_instance.rds_database_instance.arn
  description = "The ARN of the MSSQL RDS instance"
}
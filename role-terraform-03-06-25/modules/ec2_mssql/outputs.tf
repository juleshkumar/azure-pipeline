output "private_ip" {
  description = "Private IP of instance"
  value       = aws_instance.master.private_ip
}

output "private_dns" {
  description = "Private DNS of instance"
  value       = aws_instance.master.private_dns
}

output "id" {
  description = "ID of the instance"
  value       = aws_instance.master.id
}

output "arn" {
  description = "ARN of the instance"
  value       = aws_instance.master.arn
}

# Add these new outputs for the IAM role and security group
output "iam_instance_profile_name" {
  description = "Name of the IAM instance profile"
  value       = aws_iam_instance_profile.ec2_ssm_instance_profile.name
}

output "security_group_id" {
  description = "ID of the security group"
  value       = aws_security_group.securitygroup.id
}
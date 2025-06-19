output "eks_node_role_arn" {
  description = "The ARN of the EKS node role"
  value       = aws_iam_role.node.arn
}

###output "efs_security_group_id" {
###  description = "The ID of the security group for EFS mount targets"
###  value       = aws_security_group.efs_mount_target_sg.id
###}


#output "eks_node_group_names" {
#  description = "The names of all EKS node groups"
#  value       = [for i in range(length(var.node_groups_decimal)) : aws_eks_node_group.decimal[i].node_group_name]
#}

#output "eks_node_group_arns" {
#  description = "The ARNs of all EKS node groups"
#  value       = [for i in range(length(var.node_groups_decimal)) : aws_eks_node_group.decimal[i].arn]
#}

#output "eks_node_group_autoscaling_groups" {
#  description = "The autoscaling groups associated with each EKS node group"
#  value       = [for i in range(length(var.node_groups_decimal)) : aws_eks_node_group.decimal[i].resources[0].autoscaling_groups[0].name]
#}
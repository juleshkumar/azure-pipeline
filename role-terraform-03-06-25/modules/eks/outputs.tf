# EKS Cluster Outputs
output "eks_cluster_id" {
  description = "The name of the cluster"
  value       = aws_eks_cluster.eks.id
}

output "eks_cluster_arn" {
  description = "The Amazon Resource Name (ARN) of the cluster"
  value       = aws_eks_cluster.eks.arn
}

output "eks_cluster_endpoint" {
  description = "The endpoint for the Kubernetes API server"
  value       = aws_eks_cluster.eks.endpoint
}

output "eks_cluster_version" {
  description = "The Kubernetes server version of the cluster"
  value       = aws_eks_cluster.eks.version
}

output "eks_cluster_security_group_id" {
  description = "The ID of the additional EKS cluster security group"
  value       = aws_security_group.eks_cluster_additional_sg.id
}

output "eks_cluster_security_group_arn" {
  description = "The ARN of the additional EKS cluster security group"
  value       = aws_security_group.eks_cluster_additional_sg.arn
}

output "eks_cluster_certificate_authority" {
  description = "The Kubernetes cluster certificate authority data"
  value       = aws_eks_cluster.eks.certificate_authority[0].data
}

output "eks_oidc_provider_arn" {
  description = "The ARN of the OIDC Provider"
  value       = aws_iam_openid_connect_provider.example.arn
}

output "eks_oidc_provider_url" {
  description = "The URL of the OIDC Provider"
  value       = aws_iam_openid_connect_provider.example.url
}
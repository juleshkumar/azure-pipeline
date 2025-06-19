resource "aws_eks_addon" "coredns" {
  cluster_name                = var.cluster-name
  addon_name                  = "coredns"
  addon_version               = var.coredns_version
  resolve_conflicts_on_update = "PRESERVE"
}

resource "aws_eks_addon" "kube_proxy" {
  cluster_name                = var.cluster-name
  addon_name                  = "kube-proxy"
  addon_version               = var.kube_proxy_version
  resolve_conflicts_on_update = "PRESERVE"
}

resource "aws_eks_addon" "pod_identity_agent" {
  cluster_name                = var.cluster-name
  addon_name                  = "eks-pod-identity-agent"
  addon_version               = var.pod_identity_agent_version
  resolve_conflicts_on_update = "PRESERVE"
}

resource "aws_eks_addon" "s3_csi_driver" {
  cluster_name                = var.cluster-name
  addon_name                  = "aws-mountpoint-s3-csi-driver"
  addon_version               = var.s3_csi_driver_version
  resolve_conflicts_on_update = "PRESERVE"
}

resource "aws_eks_addon" "efs_csi_driver" {
  cluster_name                = var.cluster-name
  addon_name                  = "aws-efs-csi-driver"
  addon_version               = var.efs_csi_driver_version
  resolve_conflicts_on_update = "PRESERVE"
}

resource "aws_eks_addon" "vpc_cni" {
  cluster_name                = var.cluster-name
  addon_name                  = "vpc-cni"
  addon_version               = var.vpc_cni_version
  resolve_conflicts_on_update = "PRESERVE"
}

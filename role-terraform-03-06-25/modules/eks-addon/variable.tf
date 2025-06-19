variable "cluster-name" {
  type        = string
  description = "eks-cluster name for add on"
}

variable "coredns_version" {
  description = "Version of the CoreDNS addon"
  type        = string
}

variable "kube_proxy_version" {
  description = "Version of the kube-proxy addon"
  type        = string
}

variable "pod_identity_agent_version" {
  description = "Version of the pod identity agent addon"
  type        = string
}

variable "s3_csi_driver_version" {
  description = "Version of the aws-mountpoint-s3-csi-driver addon"
  type        = string
}

variable "efs_csi_driver_version" {
  description = "Version of the aws-efs-csi-driver addon"
  type        = string
}

variable "vpc_cni_version" {
  description = "Version of the vpc-cni addon"
  type        = string
}

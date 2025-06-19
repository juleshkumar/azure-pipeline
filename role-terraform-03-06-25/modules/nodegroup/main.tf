resource "tls_private_key" "nodegroups_private_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "nodegroups_key" {
  key_name   = "${var.customer_name}-${var.Environment}-nodegroups-keypair"
  public_key = tls_private_key.nodegroups_private_key.public_key_openssh
}

resource "aws_ssm_parameter" "nodegroups_private_key_ssm" {
  name        = "/${var.Environment}/ec2-keypairs/${var.customer_name}-${var.Environment}-nodegroups-keypair"
  type        = "SecureString"
  value       = tls_private_key.nodegroups_private_key.private_key_pem
  description = "Private key for ${var.customer_name}-${var.Environment}-nodegroups-keypair"
  overwrite   = true

  tags = {
    Environment = var.Environment
    Customer    = var.customer_name
  }
}

resource "aws_iam_role" "node" {
  name = "${var.customer_name}-${var.cluster-name}-${var.Environment}-node-0"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

resource "aws_iam_policy" "ebs_decryption_policy" {
  name = "${var.customer_name}-${var.cluster-name}-${var.Environment}-EBSDecryptionPolicy"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "kms:Encrypt",
          "kms:Decrypt",
          "kms:ReEncrypt*",
          "kms:GenerateDataKey*",
          "kms:DescribeKey"
        ],
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_policy" "node_ca" {
  name        = "${var.customer_name}-${var.cluster-name}-${var.Environment}-eks-node-ca"
  path        = "/"
  description = "EKS Cluster Autoscaler policy"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "autoscaling:DescribeAutoScalingGroups",
        "autoscaling:DescribeAutoScalingInstances",
        "autoscaling:DescribeLaunchConfigurations",
        "autoscaling:DescribeTags",
        "autoscaling:SetDesiredCapacity",
        "autoscaling:TerminateInstanceInAutoScalingGroup",
        "ec2:DescribeLaunchTemplateVersions"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "eks_node_AmazonEBSCSIDriverPolicy-node" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
  role       = aws_iam_role.node.name
}

resource "aws_iam_role_policy_attachment" "eks_node_AmazonEFSCsiDriverPolicy-node" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEFSCSIDriverPolicy"
  role       = aws_iam_role.node.name
}

resource "aws_iam_role_policy_attachment" "node_AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.node.name
}

resource "aws_iam_role_policy_attachment" "node_AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.node.name
}

resource "aws_iam_role_policy_attachment" "node_AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.node.name
}

resource "aws_iam_role_policy_attachment" "CloudWatchAgentServerPolicy" {
  count      = var.cloudwatch_logs ? 1 : 0
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
  role       = aws_iam_role.node.name
}

resource "aws_iam_role_policy_attachment" "node_ca" {
  policy_arn = aws_iam_policy.node_ca.arn
  role       = aws_iam_role.node.name
}

resource "aws_iam_role_policy_attachment" "attach_ebs_decryption_policy" {
  policy_arn = aws_iam_policy.ebs_decryption_policy.arn
  role       = aws_iam_role.node.name
}

resource "aws_security_group" "node_group_sg" {
  name        = "${var.customer_name}-${var.Environment}-common-nodegroup-sg"
  description = "Default SG to allow traffic"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.vpc_cidr_block]
  }
    ingress {
    from_port   = 1025
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr_block]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.customer_name}-${var.Environment}-${var.cluster-name}-common-nodegroup-sg"
  }
}

locals {
  constant_nodegroup_with_tt_tags = {
    Environment = var.Environment
    ManagedBy   = "Terraform"
  }
}
resource "aws_eks_node_group" "test" {
  count           = length(var.node_groups_test)
  cluster_name    = var.eks_cluster_id
  node_group_name = "${var.customer_name}-${var.Environment}-${var.node_groups_test[count.index].name}"
  node_role_arn   = aws_iam_role.node.arn
  subnet_ids      = var.private_subnet_ids
  instance_types = var.node_groups_test[count.index].instance_types
  capacity_type   = var.node_groups_test[count.index].capacity_type 

  launch_template {
    id      = aws_launch_template.eks_node_lt[0].id
    version = "$Latest"
  }

  labels = var.node_groups_test[count.index].labels

  taint {
    key    = var.node_groups_test[count.index].tolerations.key
    value  = var.node_groups_test[count.index].tolerations.value
    effect = var.node_groups_test[count.index].tolerations.effect
  }

  scaling_config {
    desired_size = var.node_groups_test[count.index].desired_size
    max_size     = var.node_groups_test[count.index].maximum_size
    min_size     = var.node_groups_test[count.index].minimum_size
  }

  tags = merge(
  local.constant_nodegroup_with_tt_tags,
  var.node_groups_test[count.index].ng_test_tags
)

  depends_on = [
    aws_iam_role_policy_attachment.node_AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.node_AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.node_AmazonEC2ContainerRegistryReadOnly,
  ]
}
locals {
  constant_nodegroup_no_tt_tags = {
    Environment = var.Environment
    ManagedBy   = "Terraform"
  }
}
resource "aws_eks_node_group" "test_no_tt" {
  count           = length(var.node_groups_test_tt)
  cluster_name    = var.eks_cluster_id
  node_group_name = "${var.customer_name}-${var.Environment}-${var.node_groups_test_tt[count.index].name}"
  node_role_arn   = aws_iam_role.node.arn
  subnet_ids      = var.private_subnet_ids
  instance_types = var.node_groups_test_tt[count.index].instance_types
  capacity_type   = var.node_groups_test_tt[count.index].capacity_type 

  launch_template {
    id      = aws_launch_template.eks_node_lt[0].id
    version = "$Latest"
  }

  labels = var.node_groups_test_tt[count.index].labels

  scaling_config {
    desired_size = var.node_groups_test_tt[count.index].desired_size
    max_size     = var.node_groups_test_tt[count.index].maximum_size
    min_size     = var.node_groups_test_tt[count.index].minimum_size
  }
  tags = merge(
  local.constant_nodegroup_no_tt_tags,
  var.node_groups_test_tt[count.index].ng_test_tags
)

  depends_on = [
    aws_iam_role_policy_attachment.node_AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.node_AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.node_AmazonEC2ContainerRegistryReadOnly,
  ]
}
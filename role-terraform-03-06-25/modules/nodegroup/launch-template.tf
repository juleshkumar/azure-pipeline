data "aws_ssm_parameter" "eks_ami" {
  name = "/aws/service/eks/optimized-ami/${var.k8s_version}/amazon-linux-2/recommended/image_id"
}

resource "aws_launch_template" "eks_node_lt" {
  count         = 1
  name_prefix   = "${var.customer_name}-${var.Environment}-nodegroups-lt"
  description   = "EKS node launch template."

  block_device_mappings {
    device_name = "/dev/xvda"

    ebs {
      volume_size           = var.ec2_root_volume_size
      volume_type           = "gp3"
      delete_on_termination = true
      encrypted             = true
      kms_key_id            = var.cmk_arn

    }
  }

  key_name = aws_key_pair.nodegroups_key.key_name

  image_id = data.aws_ssm_parameter.eks_ami.value

  monitoring {
    enabled = true
  }

  vpc_security_group_ids = [
      aws_security_group.node_group_sg.id,                        
      var.eks_cluster_sg_id
  ]

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name                                     = "${var.customer_name}-${var.Environment}-nodegroup"
      KubernetesCluster                        = var.cluster-name
      Environment                              = var.Environment
      "kubernetes.io/cluster/${var.cluster-name}" = "owned"
    }
  }

  user_data = base64encode(<<EOF
#!/bin/bash
set -o xtrace
/etc/eks/bootstrap.sh ${var.cluster-name}
/opt/aws/bin/cfn-signal --exit-code $? \
        --stack  ${var.cluster-name} \
        --resource NodeGroup  \
        --region us-east-1
EOF
  )
}

output "launch_template_id" {
  description = "The ID of the launch template"
  value       = aws_launch_template.eks_node_lt[0].id
}

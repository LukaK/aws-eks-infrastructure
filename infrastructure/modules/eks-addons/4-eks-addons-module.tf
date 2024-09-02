module "eks_addons" {
  source  = "aws-ia/eks-blueprints-addons/aws"
  version = "1.16.3"

  cluster_name      = var.cluster_name
  cluster_endpoint  = var.cluster_endpoint
  cluster_version   = var.cluster_version
  oidc_provider_arn = var.oidc_provider_arn

  # EKS Add-ons
  eks_addons = {
    aws-ebs-csi-driver = {
      most_recent              = true
      service_account_role_arn = module.ebs_csi_driver_irsa.iam_role_arn
    }
    vpc-cni = {
      most_recent = true
    }
    coredns = {
      most_recent = true
    }
    kube-proxy = {
      most_recent = true
    }
  }

  # Self-managed Add-ons
  enable_aws_efs_csi_driver           = var.enable_aws_efs_csi_driver
  enable_aws_load_balancer_controller = var.enable_aws_load_balancer_controller
  enable_metrics_server               = var.enable_metrics_server
  enable_cluster_autoscaler           = var.enable_cluster_autoscaler
  # enable_external_dns                 = true
  # enable_cert_manager                 = false

  # pin versions
  aws_efs_csi_driver = {
    repository    = "https://kubernetes-sigs.github.io/aws-efs-csi-driver/"
    chart_version = var.aws_efs_csi_driver_chart_version
  }

  aws_load_balancer_controller = {
    repository    = "https://aws.github.io/eks-charts"
    chart_version = var.aws_load_balancer_controller_chart_version
  }

  cluster_autoscaler = {
    repository    = "https://kubernetes.github.io/autoscaler"
    chart_version = var.cluster_autoscaler_chart_version
  }

  metrics_server = {
    repository    = "https://kubernetes-sigs.github.io/metrics-server/"
    chart_version = var.metric_server_chart_version
  }


  tags = var.tags
}

resource "aws_iam_role" "efs_csi_driver" {
  name = "${var.cluster_name}-efs-csi-driver"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "sts:AssumeRole",
          "sts:TagSession"
        ]
        Principal = {
          Service = "pods.eks.amazonaws.com"
        }
      },
    ]
  })

}

resource "aws_iam_role_policy_attachment" "efs_csi_driver" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEFSCSIDriverPolicy"
  role       = aws_iam_role.efs_csi_driver.name
}


resource "aws_eks_pod_identity_association" "efs_csi_driver" {
  cluster_name    = var.cluster_name
  namespace       = "kube-system"
  service_account = "efs-csi-controller-sa"
  role_arn        = aws_iam_role.efs_csi_driver.arn
}

resource "helm_release" "efs_csi_driver" {
  name = "aws-efs-csi-driver"

  repository = "https://kubernetes-sigs.github.io/aws-efs-csi-driver/"
  chart      = "aws-efs-csi-driver"
  namespace  = "kube-system"
  version    = "3.0.8"

  set {
    name  = "controller.serviceAccount.name"
    value = "efs-csi-controller-sa"
  }
}


# file system
resource "aws_efs_file_system" "this" {
  creation_token = "eks"

  performance_mode = "generalPurpose"
  throughput_mode  = "bursting"
  encrypted        = true
}

resource "aws_efs_mount_target" "zone" {
  for_each = toset(var.efs_storage_configuration["subnet_ids"])

  file_system_id  = aws_efs_file_system.this.id
  subnet_id       = each.key
  security_groups = var.efs_storage_configuration["security_group_ids"]
}


resource "kubernetes_storage_class_v1" "this" {
  metadata {
    name = var.efs_storage_configuration["storage_class_name"]
  }

  storage_provisioner = "efs.csi.aws.com"

  parameters = {
    provisioningMode = "efs-ap"
    fileSystemId     = aws_efs_file_system.this.id
    directoryPerms   = var.efs_storage_configuration["storage_class_directory_permissions"]
  }
}

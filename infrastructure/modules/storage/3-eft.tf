# file system
resource "aws_efs_file_system" "this" {
  creation_token = "eks"

  performance_mode = "generalPurpose"
  throughput_mode  = "bursting"
  encrypted        = true

  tags = var.tags
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

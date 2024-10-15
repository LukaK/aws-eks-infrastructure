variable "cluster_name" {
  type        = string
  description = "Eks cluster name"
}

variable "region" {
  type        = string
  description = "Aws region"
  default     = "eu-west-1"
}


variable "pod_identity_version" {
  type        = string
  description = "Version of the pod identity agent"
  default     = "v1.3.2-eksbuild.2"
}


variable "ebs_csi_driver_version" {
  type        = string
  description = "Version of the ebs csi driver."
  default     = "v1.35.0-eksbuild.1"
}

variable "cluster_autoscaler_chart_version" {
  type        = string
  description = "Helm chart version of cluster autoscaler"
  default     = "9.37.0"
}

variable "efs_storage_configuration" {
  description = "Efs storage configuration"
  type = object({
    subnet_ids                          = list(string)
    security_group_ids                  = list(string)
    storage_class_name                  = string
    storage_class_directory_permissions = string
  })
}



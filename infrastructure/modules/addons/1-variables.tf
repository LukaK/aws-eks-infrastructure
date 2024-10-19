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
  description = "Helm chart version for cluster autoscaler"
  default     = "9.37.0"
}


variable "efs_csi_chart_version" {
  type        = string
  description = "Helm chart version for efs csi driver"
  default     = "3.0.8"
}


variable "aws_lbc_chart_version" {
  type        = string
  description = "Helm chart version for aws load balancer controller"
  default     = "1.9.1"
}

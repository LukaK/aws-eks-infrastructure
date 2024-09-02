variable "cluster_name" {
  type        = string
  description = "Eks cluster name"
}

variable "cluster_endpoint" {
  type        = string
  description = "Eks cluster endpoint"
}

variable "cluster_version" {
  type        = string
  description = "Eks cluster version"
}

variable "oidc_provider_arn" {
  type        = string
  description = "Eks cluster OpenID connect provider arn"
}

variable "enable_aws_load_balancer_controller" {
  type        = bool
  description = "Flag to enable load balancer controller"
  default     = false
}

variable "aws_load_balancer_controller_chart_version" {
  type        = string
  description = "Helm chart version for load balancer controller"
  default     = "1.7.1"

}

variable "enable_metrics_server" {
  type        = bool
  description = "Flag to enable metric server"
  default     = false
}

variable "metric_server_chart_version" {
  type        = string
  description = "Helm chart version for metric server"
  default     = "3.12.0"
}


variable "enable_cluster_autoscaler" {
  type        = bool
  description = "Flag to enable cluster autoscaler"
  default     = false
}

variable "cluster_autoscaler_chart_version" {
  type        = string
  description = "Helm chart version for cluster_autoscaler"
  default     = "9.35.0"
}

variable "enable_aws_efs_csi_driver" {
  type        = bool
  description = "Flag to enable efs csi controller"
  default     = false
}

variable "aws_efs_csi_driver_chart_version" {
  type        = string
  description = "Helm chart version for efs csi driver"
  default     = "2.5.6"
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

variable "tags" {
  type    = map(string)
  default = {}
}

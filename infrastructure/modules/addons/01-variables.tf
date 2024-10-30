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


variable "metric_server_chart_version" {
  type        = string
  description = "Helm chart version for metric server"
  default     = "3.12.1"
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


variable "argocd_chart_version" {
  type        = string
  description = "Helm chart version for argocd"
  default     = "7.6.12"
}

variable "nginx_chart_version" {
  type        = string
  description = "Helm chart version for nginx"
  default     = "4.11.3"
}

variable "external_dns_chart_version" {
  type        = string
  description = "Helm chart version for external dns"
  default     = "1.15.0"
}

variable "cert_manager_chart_version" {
  type        = string
  description = "Helm chart version for cert manager"
  default     = "v1.14.5"
}

variable "cert_manager_notification_email" {
  type        = string
  description = "Email to get notified if there is an error with renewing the certificate"
}


variable "hosted_zone_name" {
  type        = string
  description = "Name of the route 53 hosted zone"
}

variable "hosted_zone_id" {
  type        = string
  description = "Route 53 hosted zone id"
}


variable "tags" {
  type    = map(string)
  default = {}
}

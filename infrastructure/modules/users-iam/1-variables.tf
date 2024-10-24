variable "cluster_name" {
  type        = string
  description = "Eks cluster name"
}


variable "admin_rbac_group_name" {
  type        = string
  description = "Kubernetes RBAC admin group"
  default     = "admin"
}


variable "viewer_rbac_group_name" {
  type        = string
  description = "Kubernetes RBAC viewer group"
  default     = "viewer"
}

variable "tags" {
  type    = map(string)
  default = {}
}

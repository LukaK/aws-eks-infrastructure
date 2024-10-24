variable "cluster_name" {
  type        = string
  description = "Eks cluster name"
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

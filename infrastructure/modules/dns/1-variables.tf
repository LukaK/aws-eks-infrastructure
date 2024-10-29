variable "domain_name" {
  type        = string
  description = "Domain name"
}

variable "tags" {
  type    = map(string)
  default = {}
}

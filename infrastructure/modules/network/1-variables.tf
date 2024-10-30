variable "cluster_name" {
  type        = string
  description = "Name of the eks cluster"
}

variable "vpc_name" {
  type        = string
  description = "Vpc name"
}

variable "cidr" {
  type        = string
  description = "Vpc cidr block"
}

variable "azs" {
  type        = list(string)
  description = "List of availability zones where networks is deployed"
}

variable "private_subnets" {
  type        = list(string)
  description = "List of private subnet cidrs"
}

variable "public_subnets" {
  type        = list(string)
  description = "List of public subnet cidrs"
}

variable "one_nat_gateway_per_az" {
  type        = bool
  description = "Deploy nat gateway for every availability zone"
  default     = false
}

variable "single_nat_gateway" {
  type        = bool
  description = "Deploy single nat gateway"
  default     = true
}

variable "sub_domain_name" {
  type        = string
  description = "Domain name"
}

variable "primary_zone_id" {
  type        = string
  description = "Primary zone id"
}

variable "primary_zone_record_name" {
  type        = string
  description = "Record name for the primary zone"
}

variable "primary_zone_record_ttl" {
  type        = number
  description = "Time to live for the dns record"
  default     = 172800
}

variable "primary_zone_ns_record_type" {
  type        = string
  description = "Primary zone record type for name servers"
  default     = "NS"
}

variable "tags" {
  type    = map(string)
  default = {}
}

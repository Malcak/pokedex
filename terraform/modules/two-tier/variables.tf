variable "environment" {
  description = "Environment name"
  type        = string
}

variable "project" {
  description = "Project name"
  type        = string
}

variable "vpc_id" {
  description = "Virtual private cloud ID"
  type        = string
}

variable "vpc_cidr" {
  description = "Virtual private cloud CIDR"
  type        = string
}

variable "redundant_zones" {
  description = "Number of availability zones where the network is deployed"
  type        = number
  default     = 1
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "project" {
  description = "Project name"
  type        = string
}

variable "vpc_cidr" {
  description = "Virtual private cloud CIDR"
  type        = string
}

variable "number_redundant_networks" {
  description = "Number of availability zones where the network is deployed"
  type        = number
  default     = 1
}

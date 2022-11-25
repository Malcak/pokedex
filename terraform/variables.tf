variable "region" {
  description = "Default region to deploy"
  type        = string
  default     = "us-east-1"
}

variable "environment" {
  description = "Environment Name"
  type        = string
  default     = "prod"
}

variable "project" {
  description = "Project Name"
  type        = string
  default     = "pokedex"
}

variable "app_count" {
  description = "Number of container running"
  type        = number
  default     = 1
}

variable "vpc_cidr" {
  type    = string
  default = "10.1.0.0/16"
}

variable "image_tag" {
  type    = string
  default = "latest"
}

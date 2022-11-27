variable "region" {
  description = "Default region to deploy"
  type        = string
  default     = "us-east-1"
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "stage"
}

variable "project" {
  description = "Project name"
  type        = string
  default     = "pokedex"
}

variable "app_count" {
  description = "Number of container running"
  type        = number
  default     = 1
}

variable "vpc_cidr" {
  description = "Virtual private cloud cidr"
  type        = string
  default     = "10.1.0.0/16"
}

variable "image_tag" {
  description = "Docker image tag"
  type        = string
  default     = "latest"
}

variable "ecr_repository_url" {
  description = "Image repository URL"
  type        = string
}

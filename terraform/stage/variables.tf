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

variable "instance_type" {
  description = "Intance type"
  type        = string
  default     = "t2.micro"
}

variable "exporter_ports" {
  description = "Metric exporter allowed ports"
  type        = list(any)
  default     = ["9100", "9200"]
}

variable "scraper_ports" {
  description = "Metric scraper allowed ports"
  type        = list(any)
  default = [
    # "22",
    # "80",
    # "443",
    "9090"
  ]
}

variable "scraper_allowed_ingress_cidr_blocks" {
  description = "Allowed inbound IPs"
  type        = list(any)
  default     = ["0.0.0.0/0"]
}

variable "app_count" {
  description = "Number of container running"
  type        = number
  default     = 2
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

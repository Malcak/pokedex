variable "region" {
  description = "Default region to deploy"
  type        = string
  default     = "us-east-1"
}

variable "project" {
  description = "Project name"
  type        = string
  default     = "pokedex"
}

variable "environments" {
  description = "List of environments"
  type        = list(string)
  default     = ["global", "stage", "prod"]
}

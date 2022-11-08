variable "region" {
  #default region to deploy infrastructure
  type    = string
  default = "us-east-1"
}

variable "environment" {
  description = "Environment Name"
  default = "dev"
}

variable "project" {
  description = "Project Name"
  default = "pokedex"
}
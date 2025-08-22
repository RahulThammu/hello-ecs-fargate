variable "project_name" {
  description = "Name of the project"
  type        = string
}

variable "environment" {
  description = "Deployment environment"
  type        = string
  default     = "dev"
}

variable "tags" {
  description = "Common tags applied to all resources"
  type        = map(string)
  default     = {}
}

variable "owner" {
  description = "Owner of the resources"
  type        = string
  default     = "rahul"
}

variable "managed_by" {
  description = "Tool managing the resources"
  type        = string
  default     = "Terraform"
}


variable "bucket_name" {
  description = "Tool managing the resources"
  type        = string
  
}

variable "bucket_arn" {
  description = "Tool managing the resources"
  type        = string
  
}

variable "ecr_repo_arn" {
  description = "Tool managing the resources"
  type        = string
  
}
variable "github_owner" {
  type = string
}

variable "github_full_repo" {
  type = string
}

variable "github_repo_name" {
  type = string
}

variable "github_branch" {
  type    = string
  default = "main"
}

variable "github_oauth_token" {
  type      = string
  sensitive = true
}
variable "s3_bucket" {
  type = string
}
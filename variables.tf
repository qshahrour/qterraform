variable "vpc_name" {
  type = string
  default = "vpc-main"
}

variable "vpc_id" {
  type = string
  default = "vpc-0773e5b7c6cb57143"
}

variable "subnet_ids" {
  type = list(string)
  default = [
    "subnet-079e2645e13f2a307",
    "subnet-026807a584d09da41"
  ]
}

variable "region" {
  default = "eu-central-1"
}

variable "github_owner" {
  type        = string
  description = "GitHub organization or user name"
  default     = "qshahrour"
}

variable "github_repo" {
  type        = string
  description = "GitHub repository name"
  default     = "frontend"
}

variable "eks_admin_policy_arn" {
  type    = string
  default = "arn:aws:iam::aws:policy/AdministratorAccess" # Or customize
}


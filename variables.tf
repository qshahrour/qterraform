#######################################################

#######################################################
variable "vpc_name" {
  type = string
  default = "main"
}

variable "vpc_id" {
  type = string
  #default = ""
  #default = "vpc-0773e5b7c6cb57143"
}

variable "subnet_ids" {
  type = string
  default = "subnet-08bedcd3bdf2e58e6"
}

variable "region" {
  default = "eu-north-1"
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

variable "main" {
  default = {
    instance_type     = "t3.medium"
    disk              = "40"
    ip_instance       = "172.31.27.120"
  }
}

/*
resource "aws_key_pair" "new" {
  key_name   = "new"
  public_key = file("new.pem")
}


*/

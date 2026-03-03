terraform {
  required_version = ">= 1.3.0"
  
  backend "s3" {
    bucket          = "eks-terraform-state-backend-shahrour"
    key             = "tfstate"
    region          = "eu-north-1"
    profile         = "default"
    encrypt         = true
    use_lockfile    = true
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "eu-north-1"
}

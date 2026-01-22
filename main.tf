terraform {
  required_version = ">= 1.3.0"
  
  backend "s3" {
    bucket          = "eks-terraform-state-backend-qasem"
    key             = "tfstate"
    region          = "us-east-1"
    profile         = "new"
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
  region = "eu-central-1"
}

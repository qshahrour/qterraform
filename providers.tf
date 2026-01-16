terraform {
  required_version = ">= 1.3.0"
  backend "s3" {
    bucket  = "eks-terraform-state-backend-qasem"
    key     = "tfstate"
    region  = "us-east-1"
    dynamodb_table = "terraform-locks"  
    profile = "new"
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.region
}


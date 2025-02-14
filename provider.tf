terraform {
  required_version = ">= 1.10.2"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.84.0"
    }
  }

  backend "s3" {
  }
}

provider "aws" {
  region = "eu-west-1"
  default_tags {
    tags = {
      Project     = var.project
      Environment = var.environment
      Region      = var.region
      ManagedBy   = "Terraform"
    }
  }
}

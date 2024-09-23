terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.32"
    }
  }

  backend "s3" {
    bucket = "raffops-teachable-terraform-backend"
    key    = "state"
    region = "us-east-1"
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region  = "us-east-1"
}

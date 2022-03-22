terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.6.0"
    }
  }

  required_version = ">= 1.1.7"
}

provider "aws" {
  profile = "default"
  region  = "us-west-2"
}
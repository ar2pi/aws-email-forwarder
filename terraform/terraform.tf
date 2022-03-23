terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.6.0"
    }
  }

  required_version = ">= 1.1.7"

  backend "s3" {
    bucket         = "aws-email-forwarder-tfstate-backend"
    key            = "terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "aws-email-forwarder-tfstate-lock"
  }
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.6.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.1.3"
    }
  }

  required_version = ">= 1.1.9"

  # backend "s3" {
  #   bucket         = "[PREFIX]-tfstate-backend-[RANDOM_GENERATED_ID]"
  #   dynamodb_table = "[PREFIX]-tfstate-lock-[RANDOM_GENERATED_ID]"
  #   key            = "terraform.tfstate"
  #   region         = "[REGION]"
  # }

  backend "s3" {
    bucket         = "aws-email-forwarder-tfstate-backend-f6e1d99b"
    dynamodb_table = "aws-email-forwarder-tfstate-lock-f6e1d99b"
    key            = "terraform.tfstate"
    region         = "us-east-2"
  }
}

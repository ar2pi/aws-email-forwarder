# @TODO: use shared sls/tf aws-cli profile instead of default
provider "aws" {
  profile = "default"
  #   profile = "terraform"
  #   shared_credentials_file = "~/.aws/credentials"
  region = var.region

  default_tags {
    tags = {
      Environment = var.env
      Service     = var.service_name
      Terraform   = "true"
    }
  }
}

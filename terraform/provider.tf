# @TODO: use shared sls/tf aws-cli profile instead of default
provider "aws" {
  profile = "default"
  #   profile = "terraform"
  #   shared_credentials_file = "~/.aws/credentials"
  region = var.region
}

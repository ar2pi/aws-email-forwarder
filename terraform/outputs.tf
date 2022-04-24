output "env" {
  value = var.env
}

output "region" {
  value = var.region
}

output "tfstate_bucket" {
  value = module.tfstate_backend.tfstate_bucket
}

output "tfstate_lock_table" {
  value = module.tfstate_backend.tfstate_lock_table
}

output "vpc_arn" {
  value = module.vpc.vpc_arn
}

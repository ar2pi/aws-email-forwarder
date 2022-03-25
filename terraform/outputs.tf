output "env" {
  value = var.env
}

output "region" {
  value = var.region
}

output "tfstate_bucket_arn" {
  value = module.tfstate_backend.tfstate_bucket_arn
}

output "tfstate_lock_table_arn" {
  value = module.tfstate_backend.tfstate_lock_table_arn
}

output "vpc_arn" {
  value = module.vpc.vpc_arn
}

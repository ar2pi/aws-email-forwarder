module "tfstate_backend" {
  source = "./modules/tfstate-backend"

  prefix = var.service_name
}

module "tfstate_backend" {
  source = "./modules/tfstate-backend"

  prefix = var.project_name
}

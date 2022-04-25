env = "dev"

# vpc
vpc_cidr                   = "10.0.0.0/16"
vpc_private_subnets        = ["10.0.128.0/20", "10.0.144.0/20"]
vpc_public_subnets         = ["10.0.0.0/20", "10.0.16.0/20"]
vpc_enable_nat_gateway     = true
vpc_single_nat_gateway     = false
vpc_one_nat_gateway_per_az = true

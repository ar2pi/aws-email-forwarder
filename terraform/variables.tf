variable "service_name" {
  description = "Service name."
  type        = string
  default     = "aws-email-forwarder"
}

variable "env" {
  description = "Environment to apply changes to."
  type        = string
  default     = "dev"
  validation {
    condition     = can(regex("dev|qa|stg|prd", var.env))
    error_message = "Env value must be one of dev|qa|stg|prd."
  }
}

variable "region" {
  description = "The region where AWS operations will take place."
  type        = string
  default     = "us-east-2"
}

#
# module.vpc variables
#

variable "vpc_azs" {
  description = "A list of availability zones names or ids in the region"
  type        = list(string)
  default     = ["us-east-2a", "us-east-2b"]
}

variable "vpc_cidr" {
  description = "The CIDR block for the VPC. Default value is a valid CIDR, but not acceptable by AWS and should be overridden"
  type        = string
  default     = "0.0.0.0/0"
}

variable "vpc_private_subnets" {
  description = "A list of private subnets inside the VPC"
  type        = list(string)
  default     = []
}

variable "vpc_public_subnets" {
  description = "A list of public subnets inside the VPC"
  type        = list(string)
  default     = []
}

variable "vpc_enable_nat_gateway" {
  description = "Should be true if you want to provision NAT Gateways for each of your private networks"
  type        = bool
  default     = false
}

variable "vpc_single_nat_gateway" {
  description = "Should be true if you want to provision a single shared NAT Gateway across all of your private networks"
  type        = bool
  default     = false
}

variable "vpc_one_nat_gateway_per_az" {
  description = "Should be true if you want only one NAT Gateway per availability zone. Requires `var.azs` to be set, and the number of `public_subnets` created to be greater than or equal to the number of availability zones specified in `var.azs`."
  type        = bool
  default     = false
}

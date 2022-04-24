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

variable "vpc_azs" {
  description = "A list of availability zones names or ids in the region"
  type        = list(string)
  default     = ["us-east-2a", "us-east-2b", "us-east-2c"]
}

variable "vpc_cidr" {
  description = "The CIDR block for the VPC. Default value is a valid CIDR, but not acceptable by AWS and should be overridden"
  type        = string
  default     = "10.0.0.0/16"
}

variable "vpc_private_subnets" {
  description = "A list of private subnets inside the VPC"
  type        = list(string)
  default     = ["10.0.128.0/20"]
}

variable "vpc_public_subnets" {
  description = "A list of public subnets inside the VPC"
  type        = list(string)
  default     = ["10.0.0.0/20"]
}

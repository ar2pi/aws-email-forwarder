variable "project_name" {
  description = "Project name."
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
  default     = "us-east-1"
}

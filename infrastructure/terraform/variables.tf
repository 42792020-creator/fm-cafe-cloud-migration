# Root-level variables used across modules

variable "cidr_block" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "public_subnet_cidr" {
  description = "CIDR block for the public subnet"
  type        = string
}

variable "app_instance_count" {
  description = "Number of application instances to deploy"
  type        = number
  default     = 1
}
variable "config_bucket_name" {
  type    = string
  default = "fm-cafe-config-bucket"
}

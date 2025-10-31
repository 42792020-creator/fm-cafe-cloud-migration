terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region                      = "us-east-1"
  access_key                  = "test"
  secret_key                  = "test"
  skip_credentials_validation = true
  skip_metadata_api_check     = true
  skip_requesting_account_id  = true
  s3_use_path_style           = true

  endpoints {
    s3   = "http://localhost:4566"
    ec2  = "http://localhost:4566"
    iam  = "http://localhost:4566"
    sts  = "http://localhost:4566"
    rds  = "http://localhost:4566"
  }
}

# Use the network module
module "network" {
  source             = "./modules/network"
  cidr_block         = "10.0.0.0/16"
  public_subnet_cidr = "10.0.1.0/24"
  name               = "fm-cafe-vpc"
}

output "vpc_id" {
  value = module.network.vpc_id
}

output "subnet_id" {
  value = module.network.subnet_id
}


resource "aws_s3_bucket" "fm_cafe_config" {
  bucket = var.config_bucket_name
  acl    = "private"
  tags = {
    Name = "fm-cafe-config"
  }
}

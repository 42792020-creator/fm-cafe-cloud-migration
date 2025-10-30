#######################################################
# LocalStack Terraform Setup for Frank & Martha’s Café
# Author: El Matador
# Description: Simple AWS-like environment using LocalStack
#######################################################

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

  endpoints {
    s3  = "http://localhost:4566"
    ec2 = "http://localhost:4566"
    rds = "http://localhost:4566"
  }

  s3_use_path_style = true
}


resource "random_id" "suffix" {
  byte_length = 2
}

#######################################################
# Example S3 Bucket
#######################################################
resource "aws_s3_bucket" "fm_cafe_bucket" {
  bucket = "fm-cafe-test-bucket-${random_id.suffix.hex}"
}

#######################################################
# Example VPC
#######################################################
resource "aws_vpc" "fm_cafe_vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "fm-cafe-vpc"
  }
}

#######################################################
# Example RDS (simulated only in LocalStack)
#######################################################
# resource "aws_db_instance" "fm_cafe_db" {
#   identifier              = "fm-cafe-db"
#   engine                  = "mysql"
#   username                = "admin"
#   password                = "password123"
#   allocated_storage       = 20
#   instance_class          = "db.t3.micro"
#   skip_final_snapshot     = true
#   publicly_accessible     = false
#   vpc_security_group_ids  = []
#   depends_on              = [aws_vpc.fm_cafe_vpc]
# }


#######################################################
# OUTPUTS
#######################################################
#######################################################
# OUTPUTS
#######################################################

output "s3_bucket_name" {
  description = "The name of the S3 bucket for FM Café project"
  value       = aws_s3_bucket.fm_cafe_bucket.bucket
}

output "vpc_id" {
  description = "The ID of the default or created VPC"
  value       = aws_vpc.fm_cafe_vpc.id
}

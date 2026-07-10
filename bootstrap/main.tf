terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  required_version = ">= 1.3.0"
}

provider "aws" {
  region = "ap-northeast-2"
}

module "backend" {
  source = "../modules/backend"

  bucket_name         = var.bucket_name
  dynamodb_table_name = var.dynamodb_table_name
  common_tags         = var.common_tags
}

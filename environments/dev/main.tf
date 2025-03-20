terraform {
  required_version = ">= 1.3.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "ap-northeast-2" # 서울 리전
}

# VPC 모듈 호출
module "vpc" {
  source             = "../../modules/vpc"
  vpc_cidr           = var.vpc_cidr
  availability_zones = var.availability_zones
  subnet_cidrs       = var.subnet_cidrs
  common_tags        = var.common_tags
}

module "ec2" {
  source               = "../../modules/ec2"
  vpc_id               = module.vpc.vpc_id
  ami_id               = var.ami_id
  instance_type        = var.instance_type
  key_name             = var.key_name
  ec2_desired_capacity = var.ec2_desired_capacity
  ec2_min_size         = var.ec2_min_size
  ec2_max_size         = var.ec2_max_size
  common_tags          = var.common_tags
  vpc_zone_identifier  = module.vpc.private_nat_subnet_ids
  ec2_sg_id            = module.ec2.ec2_sg_id
}

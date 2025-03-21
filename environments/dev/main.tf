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
  ami_id               = var.ec2_ami_id
  instance_type        = var.ec2_instance_type
  key_name             = var.key_name
  ec2_desired_capacity = var.ec2_desired_capacity
  ec2_min_size         = var.ec2_min_size
  ec2_max_size         = var.ec2_max_size
  common_tags          = var.common_tags
  vpc_zone_identifier  = module.vpc.private_nat_subnet_ids
  alb_sg_id            = module.alb.alb_sg_id
  bastion_sg_id        = module.bastion.bastion_sg_id
}

module "alb" {
  source            = "../../modules/alb"
  vpc_id            = module.vpc.vpc_id
  public_subnet_ids = module.vpc.public_subnet_ids
  certificate_arn   = var.certificate_arn
  asg_name          = module.ec2.ec2_asg_name
  common_tags       = var.common_tags
  ec2_sg_id         = module.ec2.ec2_sg_id
}

module "rds" {
  source = "../../modules/rds"

  # VPC 관련
  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnet_ids

  # EC2 보안 그룹에서만 접근 허용
  ec2_sg_id = module.ec2.ec2_sg_id

  # DB 설정
  db_identifier     = var.db_identifier
  db_name           = var.db_name
  db_username       = var.db_username
  db_password       = var.db_password
  db_port           = var.db_port
  allocated_storage = var.allocated_storage
  engine            = var.engine
  engine_version    = var.engine_version
  instance_class    = var.instance_class
  multi_az          = var.multi_az

  common_tags = var.common_tags
}

# Bastion 호스트
module "bastion" {
  source           = "../../modules/bastion"
  ami_id           = var.bastion_ami_id
  instance_type    = var.bastion_instance_type
  public_subnet_id = module.vpc.public_subnet_ids[0]
  vpc_id           = module.vpc.vpc_id
  key_name         = var.key_name

  common_tags = var.common_tags
}

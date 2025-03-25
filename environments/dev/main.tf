# main.tf

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
  region = "ap-northeast-2"
}

provider "aws" {
  alias  = "us_east"
  region = "us-east-1"
}

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
  certificate_arn   = module.acm_alb.certificate_arn
  asg_name          = module.ec2.ec2_asg_name
  common_tags       = var.common_tags
  ec2_sg_id         = module.ec2.ec2_sg_id
}

module "rds" {
  source     = "../../modules/rds"
  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnet_ids
  ec2_sg_id  = module.ec2.ec2_sg_id

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
  common_tags       = var.common_tags
}

module "bastion" {
  source           = "../../modules/bastion"
  ami_id           = var.bastion_ami_id
  instance_type    = var.bastion_instance_type
  public_subnet_id = module.vpc.public_subnet_ids[0]
  vpc_id           = module.vpc.vpc_id
  key_name         = var.key_name
  common_tags      = var.common_tags
}

module "s3_frontend" {
  source      = "../../modules/s3-static-site"
  bucket_name = var.frontend_bucket_name
  common_tags = var.common_tags
}

module "route53" {
  source                 = "../../modules/route53"
  domain_name            = var.domain_name
  cloudfront_domain_name = module.cloudfront.cloudfront_domain_name
  cloudfront_zone_id     = module.cloudfront.cloudfront_hosted_zone_id
  common_tags            = var.common_tags
  enable_rds_record      = true
  rds_endpoint           = module.rds.rds_endpoint
  rds_hostname           = module.rds.rds_hostname
  enable_api_record      = true
  api_endpoint           = module.alb.alb_dns_name
}

module "acm_alb" {
  source      = "../../modules/acm"
  domain_name = var.api_domain
  zone_id     = module.route53.route53_zone_id
  common_tags = var.common_tags
}

module "cloudfront" {
  source                = "../../modules/cloudfront"
  s3_bucket_domain_name = module.s3_frontend.bucket_domain_name
  root_domain           = var.domain_name
  zone_id               = module.route53.route53_zone_id
  common_tags           = var.common_tags
}

module "backend" {
  source = "../../modules/backend"

  bucket_name         = "20250324-glenn-tfstate"
  dynamodb_table_name = "20250324-glenn-lock"
  common_tags         = var.common_tags
}

# 테스트 1

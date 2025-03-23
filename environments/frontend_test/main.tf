provider "aws" {
  region = "ap-northeast-2"
}

provider "aws" {
  alias  = "us_east"
  region = "us-east-1"
}

module "s3_frontend" {
  source      = "../../modules/s3-static-site"
  bucket_name = var.bucket_name
  common_tags = var.common_tags
}

module "acm" {
  source = "../../modules/acm"

  domain_name               = var.custom_domain
  subject_alternative_names = []
  zone_id                   = var.route53_zone_id
  common_tags               = var.common_tags
  providers = {
    aws = aws.us_east
  }
}

module "cloudfront" {
  source = "../../modules/cloudfront"

  s3_bucket_domain_name = module.s3_frontend.bucket_domain_name
  custom_domain         = var.custom_domain
  certificate_arn       = module.acm.certificate_arn
  common_tags           = var.common_tags
}

module "route53" {
  source = "../../modules/route53"

  domain_name            = var.custom_domain
  cloudfront_domain_name = module.cloudfront.cloudfront_domain_name
  cloudfront_zone_id     = module.cloudfront.cloudfront_hosted_zone_id
  common_tags            = var.common_tags
}

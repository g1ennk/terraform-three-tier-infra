# us-east-1 리전에서만 CloudFront용 인증서 생성 가능 (필수 조건)
provider "aws" {
  alias  = "us_east"
  region = "us-east-1"
}

terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

# ACM 인증서 생성 (DNS 검증 방식)
resource "aws_acm_certificate" "cert" {
  provider          = aws.us_east
  domain_name       = var.domain_name # 기본 도메인
  validation_method = "DNS"           # DNS 검증 방식 사용

  subject_alternative_names = var.subject_alternative_names # 서브 도메인 추가

  lifecycle {
    create_before_destroy = true # 인증서 교체 시 다운타임 방지
  }

  tags = merge(var.common_tags, { Name = "acm-cert" })
}

# 인증서 검증을 위한 Route53 레코드 자동 생성
resource "aws_route53_record" "cert_validation" {
  for_each = {
    for dvo in aws_acm_certificate.cert.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      type   = dvo.resource_record_type
      record = dvo.resource_record_value
    }
  }

  zone_id = var.zone_id     # 해당 도메인의 Hosted Zone ID
  name    = each.value.name # 검증용 레코드 이름
  type    = each.value.type # 보통 CNAME
  records = [each.value.record]
  ttl     = 60
}

# DNS 검증 완료 처리
resource "aws_acm_certificate_validation" "cert_validation" {
  provider                = aws.us_east
  certificate_arn         = aws_acm_certificate.cert.arn
  validation_record_fqdns = [for record in aws_route53_record.cert_validation : record.fqdn]
}

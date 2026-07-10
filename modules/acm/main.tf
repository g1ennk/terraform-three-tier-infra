terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

# ACM 인증서 생성 (DNS 검증 방식)
resource "aws_acm_certificate" "cert" {
  domain_name               = var.domain_name
  validation_method         = "DNS"
  subject_alternative_names = var.subject_alternative_names

  # lifecycle {
  #   prevent_destroy = true
  # }

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

  zone_id = var.zone_id
  name    = each.value.name
  type    = each.value.type
  records = [each.value.record]
  ttl     = 60
}

# DNS 검증 완료 처리
resource "aws_acm_certificate_validation" "cert_validation" {
  certificate_arn         = aws_acm_certificate.cert.arn
  validation_record_fqdns = [for record in aws_route53_record.cert_validation : record.fqdn]
}

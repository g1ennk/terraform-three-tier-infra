provider "aws" {
  alias  = "us_east"
  region = "us-east-1"
}

resource "aws_acm_certificate" "cert" {
  provider                  = aws.us_east
  domain_name               = var.root_domain
  validation_method         = "DNS"
  subject_alternative_names = var.subject_alternative_names

  # lifecycle {
  #   prevent_destroy = true
  # }

  tags = merge(var.common_tags, { Name = "cloudfront-cert" })
}

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

resource "aws_acm_certificate_validation" "cert_validation" {
  provider                = aws.us_east
  certificate_arn         = aws_acm_certificate.cert.arn
  validation_record_fqdns = [for record in aws_route53_record.cert_validation : record.fqdn]
}

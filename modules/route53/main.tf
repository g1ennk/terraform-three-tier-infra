# Route 53 Hosted Zone 직접 생성
resource "aws_route53_zone" "main" {
  name = var.domain_name

  # lifecycle {
  #   prevent_destroy = true
  # }

  tags = merge(var.common_tags, { Name = "route53-zone" })
}

# Route53에서 도메인에 대한 A 레코드를 생성하여 CloudFront에 연결
resource "aws_route53_record" "cloudfront_alias" {
  zone_id = aws_route53_zone.main.id # 도메인에 해당하는 Hosted Zone ID
  name    = var.domain_name          # 연결한 도메인 
  type    = "A"

  alias {
    name                   = var.cloudfront_domain_name # CloudFront 배포 도메인
    zone_id                = var.cloudfront_zone_id     # CloudFront의 Hosted Zone ID
    evaluate_target_health = false
  }

}

# RDS 연결 CNAME 레코드
resource "aws_route53_record" "rds" {
  count   = var.enable_rds_record ? 1 : 0
  zone_id = aws_route53_zone.main.id
  name    = "rds.${var.domain_name}"
  type    = "CNAME"
  ttl     = 300
  records = [var.rds_hostname]

  # lifecycle {
  #   prevent_destroy = true
  # }

}

# ALB 연결 CNAME 레코드
resource "aws_route53_record" "api" {
  count   = var.enable_api_record ? 1 : 0
  zone_id = aws_route53_zone.main.id
  name    = "api.${var.domain_name}"
  type    = "CNAME"
  ttl     = 300
  records = [var.api_endpoint]

  # lifecycle {
  #   prevent_destroy = true
  # }
}

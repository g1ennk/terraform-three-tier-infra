# Route 53 Hosted Zone 직접 생성
resource "aws_route53_zone" "main" {
  name = var.domain_name

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


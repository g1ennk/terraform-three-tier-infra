# CloudFront에서 S3 버킷 접근을 위한 Origin Acess Control 설정
resource "aws_cloudfront_origin_access_control" "s3_oac" {
  name                              = "s3-oac"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

# CloudFront 배포 구성
resource "aws_cloudfront_distribution" "cdn" {
  enabled             = true # 배포 활성화
  default_root_object = "index.html"
  aliases             = [var.root_domain] # 예: ["www.g1enn.site", "g1enn.site"]

  lifecycle {
    prevent_destroy = true
  }

  # Origin 설정 
  origin {
    domain_name              = var.s3_bucket_domain_name # S3 버킷 도메인
    origin_id                = "s3-origin"
    origin_access_control_id = aws_cloudfront_origin_access_control.s3_oac.id
  }

  # 기본 캐시 동작 정의
  default_cache_behavior {
    allowed_methods        = ["GET", "HEAD"]
    cached_methods         = ["GET", "HEAD"]
    target_origin_id       = "s3-origin"
    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    compress               = true

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }
  }

  viewer_certificate {
    acm_certificate_arn      = var.acm_certificate_arn
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1.2_2021"
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  tags = merge(var.common_tags, { Name = "cloudfront-cdn" })
}


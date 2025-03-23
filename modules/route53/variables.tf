# 연결한 Route53 호스팅 존 ID
variable "domain_name" {
  type = string
}

# CloudFront 배포 도메인
variable "cloudfront_domain_name" {
  type = string
}

# CloudFront Hosted Zone ID
variable "cloudfront_zone_id" {
  type = string
}

# 공통 태그
variable "common_tags" {
  type = map(string)
}

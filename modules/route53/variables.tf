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

# RDS용 CNAME 레코드
variable "enable_rds_record" {
  type    = bool
  default = false
}

variable "rds_endpoint" {
  type = string
}

# ALB 연결
variable "enable_api_record" {
  type    = bool
  default = false
}
variable "api_endpoint" {
  type = string
}

variable "rds_hostname" {
  type = string
}


# 공통 태그
variable "common_tags" {
  type = map(string)
}

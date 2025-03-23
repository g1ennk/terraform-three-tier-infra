# 공통 태그
variable "common_tags" {
  type = map(string)
}

# 기본 도메인 ex) g1enn.site
variable "domain_name" {
  type = string
}

# 서브 도메인 ex) www.g1enn.site
variable "subject_alternative_names" {
  type    = list(string)
  default = []
}

# 해당 도메인의 Route53 호스팅 존 ID
variable "zone_id" {
  type = string
}

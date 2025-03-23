variable "common_tags" {
  type    = map(string)
  default = {}
}

variable "bucket_name" {
  type = string
}

variable "custom_domain" {
  type = string
}

variable "route53_zone_id" {
  type = string
}


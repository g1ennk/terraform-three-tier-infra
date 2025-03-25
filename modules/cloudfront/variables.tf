variable "common_tags" {
  type = map(string)
}

variable "s3_bucket_domain_name" {
  type = string
}

variable "root_domain" {
  type = string
}

variable "zone_id" {
  type = string
}

variable "subject_alternative_names" {
  type    = list(string)
  default = []
}

variable "acm_certificate_arn" {
  type = string
}

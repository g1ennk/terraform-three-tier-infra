variable "common_tags" {
  type = map(string)
}

variable "s3_bucket_domain_name" {
  type = string
}

variable "custom_domain" {
  type = string
}

variable "certificate_arn" {
  type = string
}

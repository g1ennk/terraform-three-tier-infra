# VPC
variable "vpc_cidr" {
  type = string
}

variable "subnet_cidrs" {
  type = map(string)
}

variable "availability_zones" {
  type = list(string)
}

variable "common_tags" {
  description = "Common tags for all resources"
  type        = map(string)
}

# EC2 설정
variable "ec2_ami_id" {
  description = "EC2 AMI ID"
  type        = string
}

variable "ec2_instance_type" {
  description = "EC2 Instance Type"
  type        = string
  default     = "t3.micro"
}

variable "key_name" {
  description = "EC2 Key Pair Name"
  type        = string
}

variable "ec2_desired_capacity" {
  description = "EC2 ASG Desired Capacity"
  type        = number
  default     = 2
}

variable "ec2_min_size" {
  description = "EC2 ASG Minimum Size"
  type        = number
  default     = 1
}

variable "ec2_max_size" {
  description = "EC2 ASG Maximum Size"
  type        = number
  default     = 3
}

# DB 설정
variable "db_identifier" {
  type = string
}

variable "db_name" {
  type = string
}

variable "db_username" {
  type = string
}

variable "db_password" {
  type      = string
  sensitive = true
}

variable "db_port" {
  type    = number
  default = 3306
}

variable "allocated_storage" {
  type    = number
  default = 20
}

variable "engine" {
  type    = string
  default = "mysql"
}

variable "engine_version" {
  type    = string
  default = "8.0"
}

variable "instance_class" {
  type    = string
  default = "db.t3.micro"
}

variable "multi_az" {
  type    = bool
  default = false
}

# Bastion 설정
variable "bastion_ami_id" {
  type = string
}

variable "bastion_instance_type" {
  type = string
}

# S3 설정
variable "frontend_bucket_name" {
  type = string
}

# Route 53 / ACM / CloudFront 관련
variable "domain_name" {
  description = "루트 도메인 (예: g1enn.site)"
  type        = string
}

variable "api_domain" {
  description = "ALB 도메인 (예: api.g1enn.site)"
  type        = string
}

variable "acm_certificate_arn_for_alb" {
  type = string
}

variable "acm_certificate_arn_for_cloudfront" {
  type = string
}

variable "cloudfront_domain_name" {
  type = string
}

variable "cloudfront_zone_id" {
  type = string
}

# 태그 관련
variable "common_tags" {
  type = map(string)
}

# SG 관련
variable "vpc_id" {
  type = string
}

# Bastion 관련
variable "ami_id" {
  type    = string
  default = "ami-062cddb9d94dcf95d" # Amazon Linux 2023 AMI
}

variable "instance_type" {
  type    = string
  default = "t3.micro"
}

variable "key_name" {
  type = string
}


# VPC 관련
variable "public_subnet_id" {
  type = string
}



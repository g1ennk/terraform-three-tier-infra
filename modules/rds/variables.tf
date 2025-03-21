# 공통 태그
variable "common_tags" {
  type = map(string)
}

# VPC 관련
variable "subnet_ids" {
  type = list(string)
}

variable "vpc_id" {
  type = string
}

# DB 관련
variable "db_port" {
  type    = number
  default = 3306
}

variable "ec2_sg_id" {
  type = string
}

variable "db_identifier" {
  type = string
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

variable "multi_az" {
  type    = bool
  default = false
}

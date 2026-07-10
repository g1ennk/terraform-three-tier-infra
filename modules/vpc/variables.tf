# VPC CIDR
variable "vpc_cidr" {
  type = string
}

# 서브넷 CIDR 맵
variable "subnet_cidrs" {
  type = map(string)
}

# 가용 영역
variable "availability_zones" {
  type = list(string)
}

# 공통 태그
variable "common_tags" {
  type = map(string)
}

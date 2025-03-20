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
variable "ami_id" {
  description = "EC2 AMI ID"
  type        = string
}

variable "instance_type" {
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


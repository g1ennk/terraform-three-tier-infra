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

variable "vpc_zone_identifier" {
  type = list(string)
}

variable "vpc_id" {
  type = string
}

# ✅ 공통 태그
variable "common_tags" {
  description = "Common tags for all resources"
  type        = map(string)
}

variable "ec2_sg_id" {
  type = string
}

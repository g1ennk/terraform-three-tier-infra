variable "common_tags" {
  type = map(string)
}

variable "codedeploy_role_name" {
  type = string
}

variable "application_name" {
  type = string
}

variable "deployment_group_name" {
  type = string
}

variable "codedeploy_bucket_name" {
  type = string
}

variable "asg_name" {
  type = string
}

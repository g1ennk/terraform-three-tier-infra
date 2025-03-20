# ✅ VPC 설정
vpc_cidr = "10.10.0.0/16"

subnet_cidrs = {
  public_a      = "10.10.1.0/24"
  public_c      = "10.10.2.0/24"
  private_nat_a = "10.10.3.0/24"
  private_nat_c = "10.10.4.0/24"
  private_a     = "10.10.5.0/24"
  private_c     = "10.10.6.0/24"
}

availability_zones = ["ap-northeast-2a", "ap-northeast-2c"]

common_tags = {
  Project     = "three-tier-infra"
  Environment = "dev"
}

# ✅ EC2 설정
ami_id               = "ami-082bce273471a2259"
instance_type        = "t2.medium"
key_name             = "keypair-kube-master"
ec2_desired_capacity = 2
ec2_min_size         = 1
ec2_max_size         = 3

# ALB 설정
certificate_arn = "arn:aws:acm:ap-northeast-2:221082195716:certificate/793410ab-871b-4cf5-a265-01c9ccba39a9~"

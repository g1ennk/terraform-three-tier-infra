# VPC
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

# EC2
ec2_ami_id           = "ami-082bce273471a2259"
ec2_instance_type    = "t2.medium"
key_name             = "keypair-kube-master"
ec2_desired_capacity = 2
ec2_min_size         = 1
ec2_max_size         = 3

# DB
db_identifier     = "dev-rds"
db_name           = "weekly_db"
db_username       = "admin"
db_password       = "alstjr11"
db_port           = 3306
allocated_storage = 20
engine            = "mysql"
engine_version    = "8.0"
instance_class    = "db.t3.micro"
multi_az          = false

# Bastion
bastion_ami_id        = "ami-0d5bb3742db8fc264"
bastion_instance_type = "t2.medium"

# S3
frontend_bucket_name = "weekly-static-site-dev"

# Domains
domain_name = "g1enn.site"
# custom_domain = "www.g1enn.site"
api_domain = "api.g1enn.site"

# subject_alternative_names = [
#   "g1enn.site",
#   "test.g1enn.site"
# ]

# ACM 관련
acm_certificate_arn_for_alb        = "arn:aws:acm:ap-northeast-2:221082195716:certificate/f0bbe942-4066-4d74-9461-a30c20a67e26"
acm_certificate_arn_for_cloudfront = "arn:aws:acm:us-east-1:221082195716:certificate/3c3921a5-d54b-4e59-9c06-d3d49579528c"

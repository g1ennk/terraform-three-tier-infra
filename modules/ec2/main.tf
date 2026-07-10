# Launch Template for EC2 Instances
resource "aws_launch_template" "ec2_lt" {
  name_prefix   = "ec2-template"
  image_id      = var.ami_id
  instance_type = var.instance_type
  key_name      = var.key_name
  iam_instance_profile {
    name = aws_iam_instance_profile.codedeploy_ec2_profile.name
  }

  network_interfaces {
    associate_public_ip_address = false
    security_groups             = [aws_security_group.ec2_sg.id]
  }

  tag_specifications {
    resource_type = "instance"
    tags          = merge(var.common_tags, { Name = "ec2-instance" })
  }

}

# Auto Scailing Group
resource "aws_autoscaling_group" "ec2_asg" {
  desired_capacity    = var.ec2_desired_capacity
  max_size            = var.ec2_max_size
  min_size            = var.ec2_min_size
  vpc_zone_identifier = var.vpc_zone_identifier

  launch_template {
    id      = aws_launch_template.ec2_lt.id
    version = aws_launch_template.ec2_lt.latest_version
  }

  tag {
    key                 = "Name"
    value               = var.ec2_tag_name
    propagate_at_launch = true
  }
}

# IAM
resource "aws_iam_role" "codedeploy_ec2_role" {
  name = "CodeDeploy-EC2-Role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "ec2.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })

  tags = var.common_tags
}

# 권한 1: CodeDeploy
resource "aws_iam_role_policy_attachment" "codedeploy_agent_policy" {
  role       = aws_iam_role.codedeploy_ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2RoleforAWSCodeDeploy"
}

# 권한 2: ECR Pull
resource "aws_iam_role_policy_attachment" "ecr_read_policy" {
  role       = aws_iam_role.codedeploy_ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryPowerUser"
}

# 권한 3: S3 Read
resource "aws_iam_role_policy_attachment" "s3_read_policy" {
  role       = aws_iam_role.codedeploy_ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
}

# EC2 인스턴스 프로파일
resource "aws_iam_instance_profile" "codedeploy_ec2_profile" {
  name = "CodeDeploy-EC2-InstanceProfile"
  role = aws_iam_role.codedeploy_ec2_role.name
}

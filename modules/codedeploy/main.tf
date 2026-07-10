resource "aws_iam_role" "codedeploy_role" {
  name = var.codedeploy_role_name
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "codedeploy.amazonaws.com"
        }
      }
    ]
  })

  tags = var.common_tags
}

resource "aws_iam_role_policy_attachment" "codedeploy_attach" {
  role       = aws_iam_role.codedeploy_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSCodeDeployRole"
}

resource "aws_iam_role_policy_attachment" "codedeploy_autoscaling_attach" {
  role       = aws_iam_role.codedeploy_role.name
  policy_arn = "arn:aws:iam::aws:policy/AutoScalingFullAccess"
}

resource "aws_iam_role_policy_attachment" "codedeploy_ec2_attach" {
  role       = aws_iam_role.codedeploy_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2FullAccess"
}

resource "aws_codedeploy_app" "backend_app" {
  name             = var.application_name
  compute_platform = "Server"
}

resource "aws_codedeploy_deployment_group" "backend_deployment_group" {
  app_name              = aws_codedeploy_app.backend_app.name
  deployment_group_name = var.deployment_group_name
  service_role_arn      = aws_iam_role.codedeploy_role.arn

  deployment_config_name = "CodeDeployDefault.AllAtOnce"

  autoscaling_groups = [var.asg_name]

  auto_rollback_configuration {
    enabled = true
    events  = ["DEPLOYMENT_FAILURE"]
  }

  deployment_style {
    deployment_option = "WITHOUT_TRAFFIC_CONTROL"
    deployment_type   = "IN_PLACE"
  }
}

resource "aws_s3_bucket" "codedeploy_bucket" {
  bucket        = var.codedeploy_bucket_name
  force_destroy = true

  tags = merge(var.common_tags, {
    Name = var.codedeploy_bucket_name
  })
}

resource "aws_s3_bucket_versioning" "codedeploy_versioning" {
  bucket = aws_s3_bucket.codedeploy_bucket.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "codedeploy_encryption" {
  bucket = aws_s3_bucket.codedeploy_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "codedeploy_block" {
  bucket = aws_s3_bucket.codedeploy_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

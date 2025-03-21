# Launch Template for EC2 Instances
resource "aws_launch_template" "ec2_lt" {
  name_prefix   = "ec2-template"
  image_id      = var.ami_id
  instance_type = var.instance_type
  key_name      = var.key_name

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
    value               = "ec2-asg"
    propagate_at_launch = true
  }
}

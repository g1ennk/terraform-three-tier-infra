output "ec2_launch_template_id" {
  description = "Launch Template ID"
  value       = aws_launch_template.ec2_lt.id
}

output "ec2_sg_id" {
  value = aws_security_group.ec2_sg.id
}

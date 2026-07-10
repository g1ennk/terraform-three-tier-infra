output "rds_endpoint" {
  value = aws_db_instance.rds.endpoint
}

output "rds_sg_id" {
  value = aws_security_group.rds_sg.id
}

output "rds_hostname" {
  value = aws_db_instance.rds.address
}

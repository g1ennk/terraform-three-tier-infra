# VPC ID
output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.main.id
}

# Subnet IDs
output "public_subnet_ids" {
  description = "List of public subnet IDs"
  value       = [aws_subnet.public_subnet_a.id, aws_subnet.public_subnet_c.id]
}

output "private_nat_subnet_ids" {
  description = "List of NAT subnets IDs"
  value       = [aws_subnet.private_nat_subnet_a.id, aws_subnet.private_nat_subnet_c.id]
}

output "private_subnet_ids" {
  description = "List of private subnet IDs"
  value       = [aws_subnet.private_subnet_a.id, aws_subnet.private_subnet_c.id]
}

# Route Table IDs
output "public_route_table_id" {
  description = "ID of the public route table"
  value       = aws_route_table.public_rt.id
}

output "private_route_table_ids" {
  description = "List of private route table IDs"
  value       = [aws_route_table.private_rt_a.id, aws_route_table.private_rt_c.id]
}

output "nat_gateway_ips" {
  description = "Elastic IPs associated with NAT Gateways"
  value       = [aws_eip.nat_gw_eip_a.public_ip, aws_eip.nat_gw_eip_c.public_ip]
}



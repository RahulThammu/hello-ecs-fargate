# VPC ID
output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.rahul_project_vpc.id
}


# Public Subnets
output "public_subnet_ids" {
  description = "List of public subnet IDs"
  value       = [
    aws_subnet.rahul_project_public_1.id,
    aws_subnet.rahul_project_public_2.id
  ]
}

# Private Subnets
output "private_subnet_ids" {
  description = "List of private subnet IDs"
  value       = [
    aws_subnet.rahul_project_private_1.id,
    aws_subnet.rahul_project_private_2.id
  ]
}

# Individual subnet IDs (if you want them separate)
output "public_subnet_1_id" {
  value = aws_subnet.rahul_project_public_1.id
}

output "public_subnet_2_id" {
  value = aws_subnet.rahul_project_public_2.id
}

output "private_subnet_1_id" {
  value = aws_subnet.rahul_project_private_1.id
}

output "private_subnet_2_id" {
  value = aws_subnet.rahul_project_private_2.id
}




# Internet Gateway
output "internet_gateway_id" {
  description = "The ID of the Internet Gateway"
  value       = aws_internet_gateway.rahul_project_igw.id
}

# NAT Gateway(s)
output "nat_gateway_ids" {
  description = "List of NAT Gateway IDs"
  value       = aws_nat_gateway.rahul_project_nat[*].id
}
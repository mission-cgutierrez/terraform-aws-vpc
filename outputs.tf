output "vpc_id" {
  value = aws_vpc.main.id
}

output "private_subnet_ids" {
  value = aws_subnet.private_subnet[*].id
}

output "public_subnet_ids" {
  value = aws_subnet.public_subnet[*].id
}

output "private_route_table_ids" {
  value = aws_route_table.private_route_table[*].id
}

output "public_route_table_ids" {
  value = aws_route_table.public_route_table[*].id
}

output "nat_gateway_ids" {
  value = aws_nat_gateway.nat_gw[*].id
}

output "dynamodb_endpoint_id" {
  value = aws_vpc_endpoint.dynamodb_endpoint.id
}

output "s3_endpoint_id" {
  value = aws_vpc_endpoint.s3_endpoint.id
}

output "elastic_ip_ids" {
  value = aws_eip.nat_eip[*].id
}

output "internet_gateway_id" {
  value = aws_internet_gateway.gw.id
}

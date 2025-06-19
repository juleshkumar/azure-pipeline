output "vpc_id" {
  value = aws_vpc.main.id
}

output "public_subnet_ids" {
  value = [
    aws_subnet.public_1.id
  ]
}

output "private_subnet_ids" {
  value = [
    aws_subnet.private_1.id,
    aws_subnet.private_2.id
  ]
}

output "private_route_table_id" {
  value = aws_route_table.private.id
}

output "igw_id" {
  value = aws_internet_gateway.igw.id
}

output "public_route_table_id" {
  value = aws_route_table.public.id
}

output "security_group_id" {
  value = aws_security_group.sg.id
}

output "vpc_cidr_block" {
  value = aws_vpc.main.cidr_block
}

output "nat_gateway_id" {
  value = aws_nat_gateway.nat.id
}

output "nat_gateway_public_ip" {
  value = aws_eip.nat.public_ip
}
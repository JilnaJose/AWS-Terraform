output "public_subnet_1_id" {
  value = aws_subnet.public_subnet_1.id
}

output "vpc_id" {
  value = aws_vpc.main.id
}

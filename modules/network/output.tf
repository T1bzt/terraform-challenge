output "subnet_id" {
  value = aws_subnet.http.id
}
output "vpc_id" {
  value = aws_vpc.terraform.id
}
output "ec2_security_group_id" {
  value = aws_security_group.web.id
}

output "private_subnet_id" {
  value=aws_subnet.private_subnet.id
}
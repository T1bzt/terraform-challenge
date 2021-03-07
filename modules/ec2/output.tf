output "http_hostname" {
  value = aws_eip.public_http.public_ip
}
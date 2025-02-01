output "instance_ip" {
  value = aws_instance.web.public_ip
}

output "eip-IP" {
  value = aws_eip.web.address
}

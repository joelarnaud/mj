output "security_group_id" {
  description = "Prometheus security group id"
  value       = aws_security_group.prometheus_sg.id
}

output "private_dns1" {
  description = "List of private DNS names assigned to the instances"
  value       = aws_instance.prometheus1.private_dns
}

output "private_dns2" {
  description = "List of private DNS names assigned to the instances"
  value       = aws_instance.prometheus2.private_dns
}

output "private_ip1" {
  description = "List of private IP addresses assigned to the instances"
  value       = aws_instance.prometheus1.private_ip
}

output "private_ip2" {
  description = "List of private IP addresses assigned to the instances"
  value       = aws_instance.prometheus2.private_ip
}
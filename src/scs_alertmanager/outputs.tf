output "security_group_id" {
  description = "Alertmanager security group id"
  value       = aws_security_group.alertmanager_sg.id
}

output "private_dns" {
  description = "List of private DNS names assigned to the instances"
  value       = module.ec2-instance.private_dns
}

output "private_ip" {
  description = "List of private IP addresses assigned to the instances"
  value       = module.ec2-instance.private_ip
}
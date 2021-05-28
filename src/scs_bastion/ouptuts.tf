output "security_group_id" {
  description = "Bastion security group id"
  value       = module.ssh-sg.this_security_group_id
}

output "private_dns" {
  description = "List of private DNS names assigned to the instances"
  value       = module.ec2-instance.private_dns
}

output "private_ip" {
  description = "List of private IP addresses assigned to the instances"
  value       = module.ec2-instance.private_ip
}

output "instance_id" {
  description = "Instance id"
  value       = module.ec2-instance.id
}

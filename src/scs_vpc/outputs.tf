output "private_subnets" {
  description = "List of IDs of private subnets"
  value       = module.scs_aws_vpc.private_subnets
}

output "public_subnets" {
  description = "List of IDs of public subnets"
  value       = module.scs_aws_vpc.public_subnets
}

output "intra_subnets" {
  description = "List of IDs of intra subnets"
  value       = module.scs_aws_vpc.intra_subnets
}

output "database_subnets" {
  description = "List of IDs of database subnets"
  value       = module.scs_aws_vpc.database_subnets
}

output "vpc_id" {
  description = "The ID of the VPC"
  value       = module.scs_aws_vpc.vpc_id
}

output "default_security_group_id" {
  description = "The ID of the security group created by default on VPC creation"
  value       = module.scs_aws_vpc.default_security_group_id
}

output "db_subnet_group_name" {
  description = "nom du subnet group des bases de données"
  value       = lower(module.scs_aws_vpc.name)
}
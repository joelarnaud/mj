# ElastiCache Cluster

resource "aws_elasticache_replication_group" "elasticache" {
  replication_group_id          = "scs-aws-${var.cluster_name}-${var.cluster_number}"
  replication_group_description = "ElastiCache cluster scs-aws-${var.cluster_name}-${var.cluster_number}"
  engine                        = var.engine
  engine_version                = var.engine_version
  number_cache_clusters         = var.number_cache_clusters
  automatic_failover_enabled    = var.automatic_failover_enabled
  node_type                     = var.node_type
  port                          = var.port
  at_rest_encryption_enabled    = var.at_rest_encryption_enabled
  transit_encryption_enabled    = var.transit_encryption_enabled
  auth_token                    = var.auth_token
  tags                          = var.tags
  subnet_group_name             = aws_elasticache_subnet_group.elasticache_subnet_group.id
  security_group_ids            = [ aws_security_group.elasticache_security_group.id ]
}

resource "aws_elasticache_subnet_group" "elasticache_subnet_group" {
  name       = "scs-aws-${var.cluster_name}-${var.cluster_number}-subnet-group"
  subnet_ids = var.subnet_ids
}

resource "aws_security_group" "elasticache_security_group" {
  name        = "scs-aws-${var.cluster_name}-${var.cluster_number}-sg"
  description = "scs-aws-${var.cluster_name}-${var.cluster_number} security group"
  vpc_id      = var.vpc_id

  ingress {
    description     = "tcp/${var.engine}"
    protocol        = "tcp"
    from_port       = var.port
    to_port         = var.port
    security_groups = var.allowed_security_groups
    self            = true
  }

  ingress {
    description = "tcp/${var.engine}"
    protocol    = "tcp"
    from_port   = var.port
    to_port     = var.port
    cidr_blocks = var.allowed_cidrs
  }

  egress {
    description = "tcp/${var.engine}"
    protocol    = "tcp"
    from_port   = 0
    to_port     = 65535
    cidr_blocks = var.allowed_cidrs
  }

  egress {
    description     = "tcp/${var.engine}"
    protocol        = "tcp"
    from_port       = 0
    to_port         = 0
    security_groups = var.allowed_security_groups
    self            = true
  }
}

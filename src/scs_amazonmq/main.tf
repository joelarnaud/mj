# Amazon MQ (for Apache ActiveMQ)

resource "aws_mq_broker" "scs_aws_amazonmq" {

  broker_name        = "scs-aws-${var.broker_name}-${var.broker_number}"
  deployment_mode    = var.deployment_mode
  engine_type        = "ActiveMQ"
  engine_version     = var.engine_version
  host_instance_type = var.instance_type
  subnet_ids         = var.subnet_ids
  security_groups    = [ aws_security_group.amazonmq_security_group.id ]

  user {
    username       = var.admin_username
    password       = var.admin_password
    groups         = ["admin"]
    console_access = true
  }

  user {
    username = var.application_username
    password = var.application_password
  }
}

resource "aws_security_group" "amazonmq_security_group" {
  name        = "scs-aws-${var.broker_name}-${var.broker_number}-sg"
  description = "scs-aws-${var.broker_name}-${var.broker_number} security group"
  vpc_id      = var.vpc_id

  dynamic "ingress" {
    for_each = length(var.allowed_security_groups)>0 ? var.allowed_protocols : []
    content {
      description     = "tcp/${ingress.value}"
      protocol        = "tcp"
      from_port       = var.protocols[ingress.value]
      to_port         = var.protocols[ingress.value]
      security_groups = var.allowed_security_groups
    }
  }

  dynamic "ingress" {
    for_each = length(var.allowed_cidrs)>0 ? var.allowed_protocols : []
    content {
      description = "tcp/${ingress.value}"
      protocol    = "tcp"
      from_port   = var.protocols[ingress.value]
      to_port     = var.protocols[ingress.value]
      cidr_blocks = var.allowed_cidrs
    }
  }

  ingress {
    description = "self"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    self        = true
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

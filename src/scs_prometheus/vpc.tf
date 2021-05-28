#Prometheus Security group
resource "aws_security_group" "prometheus_sg" {
  name        = "scs_aws_${var.scs_workload}_${var.scs_environment}_prometheus_sg"
  description = "Allow access to prometheus instance"
  vpc_id      = var.vpc_id

  ingress {
    description = "SSH from Ansible"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.ssh_authorized_cidr
  }

  ingress {
    description = "Prometheus Endpoint"
    from_port   = var.prometheus_port
    to_port     = var.prometheus_port
    protocol    = "tcp"
    cidr_blocks = var.endpoint_authorized_cidr
  }

  ingress {
    description = "Blackbox Endpoint"
    from_port   = var.blackbox_port
    to_port     = var.blackbox_port
    protocol    = "tcp"
    cidr_blocks = var.endpoint_authorized_cidr
  }

  ingress {
    description = "Pushgateway Endpoint"
    from_port   = var.pushgateway_port
    to_port     = var.pushgateway_port
    protocol    = "tcp"
    cidr_blocks = var.endpoint_authorized_cidr
  }

  ingress {
    description = "Prometheus proxy"
    from_port   = var.promxy_port
    to_port     = var.promxy_port
    protocol    = "tcp"
    cidr_blocks = var.promxy_authorized_cidr
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name                  = "scs_aws_${var.scs_workload}_${var.scs_environment}_prometheus_sg"
    Terraform             = "true"
    Environment           = var.scs_environment
    scs-hebergPrometheus  = "true"
  }
}

##########################
# CUSTOM SECURITY GROUPS #
##########################

resource "aws_security_group_rule" "prometheus_ssh" {
  count                    = length(var.ssh_allowed_security_group_ids) > 0 ? length(var.ssh_allowed_security_group_ids) : 0
  description              = "Allow security group member to communicate with prometheus over SSH."
  protocol                 = "TCP"
  security_group_id        = aws_security_group.prometheus_sg.id
  source_security_group_id = var.ssh_allowed_security_group_ids[count.index]
  from_port                = 22
  to_port                  = 22
  type                     = "ingress"
}

resource "aws_security_group_rule" "prom_to_eks_workers" {
  count                    = var.eks_worker_security_group_id != null ? 1 : 0
  description              = "Allow security group EKS workers to communicate with prometheus over SSH."
  protocol                 = "-1"
  security_group_id        = var.eks_worker_security_group_id
  source_security_group_id = aws_security_group.prometheus_sg.id
  from_port                = 0
  to_port                  = 0
  type                     = "ingress"
}

#ALB security group
resource "aws_security_group" "prometheus_elb_sg" {
  name        = "scs_aws_${var.scs_workload}_${var.scs_environment}_prometheus_elb_sg"
  description = "Allow access to prometheus load balancer"
  vpc_id      = var.vpc_id

  ingress {
    description = "Prometheus Endpoint"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = var.endpoint_authorized_cidr
  }

  ingress {
    description = "Prometheus proxy"
    from_port   = var.promxy_port
    to_port     = var.promxy_port
    protocol    = "tcp"
    cidr_blocks = var.promxy_authorized_cidr
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name                  = "scs_aws_${var.scs_workload}_${var.scs_environment}_prometheus_elb_sg"
    Terraform             = "true"
    Environment           = var.scs_environment
    scs-hebergPrometheus  = "true"
  }
}
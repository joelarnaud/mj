# Alertmanager Host
provider "aws" {
  alias = "scs-aws-account"
}

####################
# Alertmanager EC2 #
####################

module "ec2-instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "= 2.15.0"
  name           = "scs_aws_${var.scs_workload}_${var.scs_environment}_ec2_alertmanager"
  instance_count = var.instance_count
  vpc_security_group_ids = [aws_security_group.alertmanager_sg.id]
  ami                    = var.ami_id
  instance_type          = var.instance_type
  monitoring             = true
  use_num_suffix         = true
  subnet_ids             = var.subnet_ids
  tags = {
    Terraform   = "true"
    Environment = var.scs_environment
    Workload    = var.scs_workload
    scs-hebergAlertmanager  = "true"
    scs-os      = "linux"
  }
  providers = { aws = aws.scs-aws-account }
}

#Alertmanager Security group
resource "aws_security_group" "alertmanager_sg" {
  name        = "scs_aws_${var.scs_workload}_${var.scs_environment}_alertmanager_sg"
  description = "Allow access to alertmanager instance"
  vpc_id      = var.vpc_id

  ingress {
    description = "SSH from Ansible"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.ssh_authorized_cidr
  }

  ingress {
    description = "Alertmanager Endpoint"
    from_port   = var.alertmanager_port
    to_port     = var.alertmanager_port
    protocol    = "tcp"
    cidr_blocks = var.endpoint_authorized_cidr
  }

  ingress {
    description = "Alertmanager cluster peer"
    from_port   = var.alertmanager_cluster_port
    to_port     = var.alertmanager_cluster_port
    protocol    = "tcp"
    cidr_blocks = var.cluster_authorized_cidr
  }

  ingress {
    description = "Alertmanager cluster peer"
    from_port   = var.alertmanager_cluster_port
    to_port     = var.alertmanager_cluster_port
    protocol    = "udp"
    cidr_blocks = var.cluster_authorized_cidr
  }
  
  ingress {
    description = "Karma Dashboard endpoint"
    from_port   = var.dashboard_port
    to_port     = var.dashboard_port
    protocol    = "tcp"
    cidr_blocks = var.dashboard_authorized_cidr
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name                    = "scs_aws_${var.scs_workload}_${var.scs_environment}_alertmanager_sg"
    Terraform               = "true"
    Environment             = var.scs_environment
    scs-hebergAlertmanager  = "true"
  }
}

##########################
# CUSTOM SECURITY GROUPS #
##########################

resource "aws_security_group_rule" "alertmanager_ssh" {
  count = length(var.ssh_allowed_security_group_ids) > 0 ? length(var.ssh_allowed_security_group_ids) : 0
  description              = "Allow security group member to communicate with alertmanager over SSH."
  protocol                 = "TCP"
  security_group_id        = aws_security_group.alertmanager_sg.id
  source_security_group_id = var.ssh_allowed_security_group_ids[count.index]
  from_port                = 22
  to_port                  = 22
  type                     = "ingress"
}

#########################
# Register alertmanager #
#########################

# Record
resource "aws_route53_record" "scs-aws-route53-private-subnet-alertmanager" {
  count    = var.instance_count
  name     = "alertmanager-${count.index + 1}"
  type     = "A"
  records  = [module.ec2-instance.private_ip[count.index]]
  zone_id  = var.zone_id
  provider = aws.scs-aws-account
  ttl      = "3600"
}

##################
# Load Balancer  #
##################
module "alb" {
  source  = "terraform-aws-modules/alb/aws"
  version = "= 5.9.0"

  name = (var.scs_workload == "lab" ? "scs-${var.scs_workload}-${var.scs_environment}-${var.scs_vpc_number}-alertmanager":"scs-${var.scs_workload}-${var.scs_environment}-alertmanager")

  load_balancer_type = "application"
  internal           = true
  vpc_id             = var.vpc_id
  subnets            = var.subnet_ids
  security_groups    = [aws_security_group.alertmanager_elb_sg.id]

  target_groups = [
    {
      name_prefix          = "alert-"
      backend_protocol     = "HTTP"
      backend_port         = var.alertmanager_port
      target_type          = "instance"
      deregistration_delay = 15
      health_check = {
        enabled             = true
        interval            = 30
        path                = "/-/healthy"
        port                = "traffic-port"
        healthy_threshold   = 3
        unhealthy_threshold = 3
        timeout             = 6
        protocol            = "HTTP"
        matcher             = "200-399"
      }
      tags = {
        InstanceTargetGroupTag = "alertmanager"
      }
    },
    {
      name_prefix          = "karma-"
      backend_protocol     = "HTTP"
      backend_port         = var.dashboard_port
      target_type          = "instance"
      deregistration_delay = 15
      health_check = {
        enabled             = true
        interval            = 30
        path                = "/health"
        port                = "traffic-port"
        healthy_threshold   = 3
        unhealthy_threshold = 3
        timeout             = 6
        protocol            = "HTTP"
        matcher             = "200-399"
      }
      tags = {
        InstanceTargetGroupTag = "alertmanager_dashboard"
      }
    }
  ]

  http_tcp_listeners = [
    {
      port               = 80
      protocol           = "HTTP"
      target_group_index = 0
    },
    {
      port               = var.dashboard_port
      protocol           = "HTTP"
      target_group_index = 1
    }
  ]

  tags = {
    Terraform   = "true"
    Environment = var.scs_environment
    scs-hebergPrometheus  = "true"
  }
  providers = { aws = aws.scs-aws-account }
}

#Attach target to Alertmanager ALB target group
resource "aws_lb_target_group_attachment" "alertmanager_alb_target" {
  count    = var.instance_count
  target_group_arn = module.alb.target_group_arns[0]
  target_id        = module.ec2-instance.id[count.index]
  port             = var.alertmanager_port
}

#Attach target to Alertmanager dashboard ALB target group
resource "aws_lb_target_group_attachment" "dashboard_alb_target" {
  count    = var.instance_count
  target_group_arn = module.alb.target_group_arns[1]
  target_id        = module.ec2-instance.id[count.index]
  port             = var.dashboard_port
}

# Record ALB CNAME
resource "aws_route53_record" "scs-aws-route53-private-subnet-alertmanager-alb" {
  name     = "alertmanager"
  type     = "A"
  zone_id  = var.zone_id

  alias {
    name                   = module.alb.this_lb_dns_name
    zone_id                = module.alb.this_lb_zone_id
    evaluate_target_health = true
  }
  provider = aws.scs-aws-account
}


#ALB security group
resource "aws_security_group" "alertmanager_elb_sg" {
  name        = "scs_aws_${var.scs_workload}_${var.scs_environment}_alertmanager_elb_sg"
  description = "Allow access to alertmanager load balancer"
  vpc_id      = var.vpc_id

  ingress {
    description = "Alertmanager Endpoint"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = var.endpoint_authorized_cidr
  }

  ingress {
    description = "Karma Dashboard"
    from_port   = var.dashboard_port
    to_port     = var.dashboard_port
    protocol    = "tcp"
    cidr_blocks = var.dashboard_authorized_cidr
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name                  = "scs_aws_${var.scs_workload}_${var.scs_environment}_alertmanager_elb_sg"
    Terraform             = "true"
    Environment           = var.scs_environment
    scs-hebergPrometheus  = "true"
  }
}
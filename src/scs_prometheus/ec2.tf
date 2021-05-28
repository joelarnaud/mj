#################
# Load Balancer #
#################

module "alb" {
  source  = "terraform-aws-modules/alb/aws"
  version = "= 5.9.0"

  name = (var.scs_workload == "lab" ? "scs-${var.scs_workload}-${var.scs_environment}-${var.scs_vpc_number}-prometheus":"scs-${var.scs_workload}-${var.scs_environment}-prometheus")

  load_balancer_type = "application"
  internal           = true
  vpc_id             = var.vpc_id
  subnets            = var.subnet_ids
  security_groups    = [aws_security_group.prometheus_elb_sg.id]

  target_groups = [
    {
      name_prefix          = "prom-"
      backend_protocol     = "HTTP"
      backend_port         = var.prometheus_port
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
        InstanceTargetGroupTag = "prometheus"
      }
    },
    {
      name_prefix          = "proxy-"
      backend_protocol     = "HTTP"
      backend_port         = var.promxy_port
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
        InstanceTargetGroupTag = "prometheus_proxy"
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
      port               = var.promxy_port
      protocol           = "HTTP"
      target_group_index = 1
    }
  ]

  tags = {
    Terraform   = "true"
    Environment = var.scs_environment
    scs-hebergPrometheus  = "true"
  }
}

#Attach target to Prometheus ALB target group
resource "aws_lb_target_group_attachment" "prometheus_alb_target1" {
  target_group_arn = module.alb.target_group_arns[0]
  target_id        = aws_instance.prometheus1.id
  port             = var.prometheus_port
}

resource "aws_lb_target_group_attachment" "prometheus_alb_target2" {
  target_group_arn = module.alb.target_group_arns[0]
  target_id        = aws_instance.prometheus2.id
  port             = var.prometheus_port
}

#Attach target to Prometheus promxy ALB target group
resource "aws_lb_target_group_attachment" "promxy_alb_target1" {
  target_group_arn = module.alb.target_group_arns[1]
  target_id        = aws_instance.prometheus1.id
  port             = var.promxy_port
}

resource "aws_lb_target_group_attachment" "promxy_alb_target2" {
  target_group_arn = module.alb.target_group_arns[1]
  target_id        = aws_instance.prometheus2.id
  port             = var.promxy_port
}
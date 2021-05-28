# Bastion Host
provider "aws" {
  alias = "scs-aws-account"
}


resource "aws_kms_key" "this" {
  description             = "KMS Key for ${var.scs_workload}_${var.scs_environment}_ec2_${var.bastion_name} Bastion EBS"
  deletion_window_in_days = 10
  tags = {
    Terraform   = "true"
    Name        = "scs_aws_${var.scs_workload}_${var.scs_environment}_ec2_${var.bastion_name}_kms"
    Environment = var.scs_environment
    Workload    = var.scs_workload
  }
}

module "ec2-instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "= 2.15.0"

  name           = "scs_aws_${var.scs_workload}_${var.scs_environment}_ec2_${var.bastion_name}"
  instance_count = 1

  # Amazon Linux 2 ( Outils AWS Installé )
  ami                    = var.ami_id
  instance_type          = "t3.micro"
  iam_instance_profile   = var.iam_instance_profile
  monitoring             = true
  vpc_security_group_ids = [module.ssh-sg.this_security_group_id]
  subnet_ids             = var.subnet_ids

  #storage
  root_block_device = [{
    volume_type = "gp2"
    volume_size = var.volume_size
    encrypted   = true
    kms_key_id  = aws_kms_key.this.arn
  }]

  tags = {
    Terraform   = "true"
    Environment = var.scs_environment
    Workload    = var.scs_workload
    scs-os      = "linux"
  }
  providers = { aws = aws.scs-aws-account }
}

# Security Group
module "ssh-sg" {
  name                = "scs_aws_${var.scs_workload}_${var.scs_environment}_bastion_ssh_sg"
  source              = "terraform-aws-modules/security-group/aws//modules/ssh"
  version             = "= 3.17.0"
  vpc_id              = var.vpc_id
  ingress_cidr_blocks = var.authorized_cidr
  providers           = { aws = aws.scs-aws-account }
}

##################################
# Register bastion #
##################################

# Record
resource "aws_route53_record" "scs-aws-route53-private-subnet-bastion" {
  name     = var.bastion_name
  type     = "A"
  records  = [module.ec2-instance.private_ip[0]]
  zone_id  = var.zone_id
  provider = aws.scs-aws-account
  ttl      = "3600"
}
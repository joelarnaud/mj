# Prometheus Host
resource "aws_instance" "prometheus1" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  availability_zone      = var.prometheus1_az
  monitoring             = true
  subnet_id              = var.subnet_ids[0]
  vpc_security_group_ids = [aws_security_group.prometheus_sg.id]

  tags = {
    Terraform   = "true"
    Environment = var.scs_environment
    Workload    = var.scs_workload
    scs-hebergPrometheus  = "true"
    scs-os      = "linux"
    Name        = "scs_aws_${var.scs_workload}_${var.scs_environment}_ec2_prometheus_1"
  }
}

resource "aws_instance" "prometheus2" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  availability_zone      = var.prometheus2_az
  monitoring             = true
  subnet_id              = var.subnet_ids[1]
  vpc_security_group_ids = [aws_security_group.prometheus_sg.id]

  tags = {
    Terraform   = "true"
    Environment = var.scs_environment
    Workload    = var.scs_workload
    scs-hebergPrometheus  = "true"
    scs-os      = "linux"
    Name        = "scs_aws_${var.scs_workload}_${var.scs_environment}_ec2_prometheus_2"
  }
}

resource "aws_ebs_volume" "prometheus_tsdb_1" {
  availability_zone = aws_instance.prometheus1.availability_zone
  size              = var.disk_size

  tags = {
    Name = "scs_aws_${var.scs_workload}_${var.scs_environment}_prometheus_tsdb_1"
  }
}

resource "aws_ebs_volume" "prometheus_tsdb_2" {
  availability_zone = aws_instance.prometheus2.availability_zone
  size              = var.disk_size

  tags = {
    Name = "scs_aws_${var.scs_workload}_${var.scs_environment}_prometheus_tsdb_2"
  }
}

resource "aws_volume_attachment" "prometheus_tsdb_att1" {
  device_name = "/dev/sdh"
  volume_id   = aws_ebs_volume.prometheus_tsdb_1.id
  instance_id = aws_instance.prometheus1.id
}

resource "aws_volume_attachment" "prometheus_tsdb_att2" {
  device_name = "/dev/sdh"
  volume_id   = aws_ebs_volume.prometheus_tsdb_2.id
  instance_id = aws_instance.prometheus2.id
}
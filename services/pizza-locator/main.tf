provider "aws" {
  # The AWS region in which all resources will be created
  region = var.aws_region

  # Only these AWS Account IDs may be operated on by this template
  allowed_account_ids = [var.aws_account_id]
}


resource "aws_launch_configuration" "pizza-launch-config" {
  iam_instance_profile = aws_iam_instance_profile.pizza-instance-profile.name
  image_id             = data.aws_ami.amazon_ami.id
  instance_type        = var.ec2_instance_type
  key_name             = var.ec2_key_name
  name_prefix          = "${var.pizza_hostname}"
  security_groups      = [aws_security_group.sg_pizza.id]
  user_data = <<-EOF
    #!/usr/bin/env bash

    PIZZA_ENV="${data.aws_region.current.name}"

    ${file("${path.module}/user-data-vault.sh")}
  EOF

  root_block_device {
    volume_size = "50"
  }
  lifecycle {
    create_before_destroy = true
  }
}


resource "aws_autoscaling_group" "pizza-asg" {
  desired_capacity          = var.pizza_asg_instance_count
  health_check_grace_period = 60
  health_check_type         = "EC2"
  launch_configuration      = aws_launch_configuration.pizza-launch-config.name
  max_size                  = 5
  min_size                  = 2
  name                      = "${var.pizza_hostname}-asg"
  suspended_processes       = ["ReplaceUnhealthy"]
  target_group_arns         = [aws_lb_target_group.alb_pizza_target_group.arn, aws_lb_target_group.alb_portainer_pizza_target_group.arn]
  vpc_zone_identifier       = [data.aws_subnet.selected.id]
}


resource "aws_autoscaling_policy" "pizza-scaling-policy" {
  name                   = "pizza-scaling-policy"
  scaling_adjustment     = 4
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.pizza-asg.name
}


data "aws_subnet" "subnets" {
  count = length(
    data.terraform_remote_state.vpc.outputs.private_app_subnet_ids,
  )
  id = data.terraform_remote_state.vpc.outputs.private_app_subnet_ids[count.index]
}


data "aws_ami" "amazon_ami" {
  owners      = [var.aws_account_id]
  filter {
    name   = "owner-id"
    values = [var.aws_account_id]
  }
  filter {
    name   = "name"
    values = ["thats-amore-*-01-amazon-linux-*"]
  }
  most_recent = true
}


data "aws_subnet" "selected" {
  id = element(
    data.terraform_remote_state.vpc.outputs.private_app_subnet_ids,
    0,
  )
}


resource "aws_ebs_volume" "pizza-ebs" {
  availability_zone = data.aws_subnet.selected.availability_zone
  size              = 500
  type              = "gp2"
  tags = merge(
    {
      "Name"   = "pizza-ebs"
      "Backup" = var.ebs_backups
    },
    var.tags,
  )
}

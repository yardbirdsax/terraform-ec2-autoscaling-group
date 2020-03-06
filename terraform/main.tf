provider aws {
    region = var.aws_region
}

data aws_ami "ubuntu" {
  most_recent = true

  filter {
    name = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]
  }
  owners = ["099720109477"]
}

resource aws_key_pair k3s_keypair {
  key_name = var.deployment_name
  public_key = file(var.keypair_path)
}

resource aws_iam_instance_profile instance_profile {
  name = "${var.deployment_name}-InstanceProfile"
  role = var.iam_role_name
  count = var.iam_role_name == "" ? 0 : 1
}

resource aws_launch_template launch_template {
  dynamic "iam_instance_profile" {
    for_each = var.iam_role_name == "" ? [] : [ var.iam_role_name ]
    content {
      name = var.iam_role_name
    }
  }
  vpc_security_group_ids = var.security_group_ids
  image_id = data.aws_ami.ubuntu.image_id
  instance_type = var.instance_type
  key_name = aws_key_pair.k3s_keypair.key_name
  name = var.deployment_name
}

resource aws_autoscaling_group as_group {
  name_prefix = var.deployment_name
  desired_capacity = var.desired_instance_count
  launch_template {
    id = aws_launch_template.launch_template.id
    version = aws_launch_template.launch_template.latest_version
  }
  min_size = var.min_instance_count
  max_size = var.max_instance_count
  vpc_zone_identifier = var.subnet_ids

  tags = [
    {
      key = "Name",
      value = var.deployment_name,
      propagate_at_launch = true
    }
  ]
}

# resource aws_instance instance {
#   count = var.instance_count
#   ami = data.aws_ami.ubuntu.id
#   associate_public_ip_address = var.assign_public_ip
#   instance_type = var.instance_type
#   key_name = aws_key_pair.k3s_keypair.key_name
#   iam_instance_profile = var.iam_role_name == "" ? "" : aws_iam_instance_profile.instance_profile[0].name
#   subnet_id = var.subnet_ids[count.index % length(var.subnet_ids)]
#   vpc_security_group_ids = var.security_group_ids
#   user_data = data.template_cloudinit_config.userData[count.index].rendered
#   tags = {
#     Name = "${var.deployment_name}-${count.index}"
#   }
# }

output auto_scaling_group {
    value = aws_autoscaling_group.as_group
}
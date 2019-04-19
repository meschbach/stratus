########################################################################################################################
# Nebulosus - Simple Cloud
#
# Core Autoscale Gorup
########################################################################################################################

############################################################
#
############################################################

#############################
#
#############################
resource "aws_autoscaling_group" "core" {
  name_prefix = "${var.org-prefix}-nebulosus"

  desired_capacity = "${var.min-count}"
  min_size = "${var.min-count}"
  max_size = "${var.max-count}"

  vpc_zone_identifier = ["${aws_subnet.core.*.id}"]
  launch_template {
    id = "${aws_launch_template.primary.id}"
    version = "$Latest"
  }

  tag {
    key = "name"
    propagate_at_launch = true
    value = "${var.org-prefix}-nebulosus-${var.region}"
  }

  tag {
    key = "region"
    propagate_at_launch = true
    value = "${var.region}"
  }

  tag {
    key = "cost-center"
    propagate_at_launch = true
    value = "${var.cost-center}"
  }
}

resource "aws_launch_template" "primary" {
  #
  # Naming
  #
  name_prefix = "${var.org-prefix}-nebulosus"
  description = "${var.org-prefix} Nebulosus ${var.instance-type} Template"

  #
  # Instance configuration
  #
  ebs_optimized = "true"
  image_id = "${var.instance-ami}"
  instance_type = "${var.instance-type}"
  iam_instance_profile {
    arn = "${aws_iam_instance_profile.primary.arn}"
  }

  #
  # Network
  #
  vpc_security_group_ids = ["${aws_security_group.instance-group.id}"]

  instance_initiated_shutdown_behavior = "terminate"
  key_name = "${var.key-name}"
  credit_specification {
    cpu_credits = "standard"
  }

  tags {
    name = "${var.org-prefix}-nebulosus"
    region = "${var.region}"
    cost-center = "${var.cost-center}"
  }
}

############################################################
# IAM
############################################################

#############################
# IAM Role
#############################
resource "aws_iam_role" "primary" {
  name_prefix = "${var.org-prefix}-nebulosus"
  description = "Instance role for ${var.org-prefix}-nebulosus primary role"

  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": "sts:AssumeRole",
            "Principal": {
               "Service": "ec2.amazonaws.com"
            },
            "Effect": "Allow",
            "Sid": "allowNodeAssumption"
        }
    ]
}
EOF

  tags {
    name = "${var.org-prefix}-nebulosus"
    region = "${var.region}"
    cost-center = "${var.cost-center}"
  }
}

#############################
# Instance Profiles
#############################
resource "aws_iam_instance_profile" "primary" {
  name_prefix = "${var.org-prefix}-nebulosus"
  role = "${aws_iam_role.primary.name}"
}

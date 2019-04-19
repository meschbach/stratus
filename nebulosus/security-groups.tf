########################################################################################################################
# Nebulosus - Simple Cloud
#
# Core Security Group
########################################################################################################################

############################################################
#
############################################################

#############################
# Primary Instance SG
#############################
resource "aws_security_group" "instance-group" {
  name_prefix = "${var.org-prefix}-nebulosus"
  description = "Default security group for ${var.org-prefix}-nebulosus"

  vpc_id = "${aws_vpc.core.id}"

  revoke_rules_on_delete = true

  tags {
    name = "${var.org-prefix}-nebulosus"
    region = "${var.region}"
    cost-center = "${var.cost-center}"
  }
}

#############################
# Default SSH rule
#############################
resource "aws_security_group_rule" "default-ssh" {
  security_group_id = "${aws_security_group.instance-group.id}"
  from_port = 22
  to_port = 22
  protocol = "tcp"
  type = "ingress"
  cidr_blocks = ["0.0.0.0/0"]
  description = "Public SSH"

  count = "${var.sg-public-ssh ? 1 : 0}"
}


#############################
# Allow HTTP and HTTPS out
#############################
resource "aws_security_group_rule" "out-http-inet" {
  security_group_id = "${aws_security_group.instance-group.id}"
  from_port = 80
  to_port = 80
  protocol = "tcp"
  type = "egress"
  cidr_blocks = ["0.0.0.0/0"]
  description = "HTTP"
}

resource "aws_security_group_rule" "out-https-inet" {
  security_group_id = "${aws_security_group.instance-group.id}"
  from_port = 443
  to_port = 443
  protocol = "tcp"
  type = "egress"
  cidr_blocks = ["0.0.0.0/0"]
  description = "HTTPS"
}

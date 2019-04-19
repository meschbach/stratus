########################################################################################################################
# Nebulosus - Simple Cloud
#
# VPC
########################################################################################################################

############################################################
# Core VPC configuration
############################################################

#############################
# VPC
#############################
resource "aws_vpc" "core" {
  # Requires a /16 subnet
  cidr_block = "${local.core-cidr4}"

  tags {
    name = "${var.org-prefix}-nebulosus"
    region = "${var.region}"
    cost-center = "${var.cost-center}"
  }
}

resource "aws_subnet" "core" {
  count = "${length(var.azs)}"
  cidr_block = "${cidrsubnet(aws_vpc.core.cidr_block, local.zone-bits, lookup(local.zone-enum, element(var.azs, count.index)))}"
  vpc_id = "${aws_vpc.core.id}"
  availability_zone = "${var.region}${element(var.azs, count.index)}"

  map_public_ip_on_launch = true

  tags {
    name = "${var.org-prefix}-nebulosus-${var.region}${element(var.azs, count.index)}"
    region = "${var.region}"
    az = "${var.region}${element(var.azs, count.index)}"
    cost-center = "${var.cost-center}"
  }
}

#############################
# Internet Accessibility
#############################
resource "aws_internet_gateway" "internet" {
  vpc_id = "${aws_vpc.core.id}"

  tags {
    name = "${var.org-prefix}-nebulosus-${var.region}${element(var.azs, count.index)}"
    region = "${var.region}"
    az = "${var.region}${element(var.azs, count.index)}"
    cost-center = "${var.cost-center}"
  }
}

resource "aws_route" "internet-route" {
  route_table_id = "${aws_vpc.core.default_route_table_id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = "${aws_internet_gateway.internet.id}"
}

############################################################
# Variable Calculations
############################################################

#############################
# Calculated Values
#############################
locals {
  core-cidr4 = "${cidrsubnet(local.regional-cidr4, 4, 0)}"
  regional-cidr4 = "${cidrsubnet(local.global-cidr4, local.regional-bits, lookup(local.regional-enum, var.region))}"
}

#############################
# Constants
#############################
locals {
  global-cidr4 = "10.0.0.0/8"

  regional-enum = {
    "us-east-1" = 0
    "us-east-2" = 1
    "us-west-1" = 2
    "us-west-2" = 3
  }
  regional-bits = 4

  zone-enum = {
    a = 0
    b = 1
    c = 2
    d = 3
    e = 4
    f = 5
    g = 6
    h = 7
  }
  zone-bits = 3 # there is a us-east-1f
}

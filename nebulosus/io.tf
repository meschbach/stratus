########################################################################################################################
# Nebulosus - Simple Cloud
#
# IO Variables
########################################################################################################################

############################################################
# Inputs
############################################################

#############################
# Naming & Cost
#############################
variable "org-prefix" {
  description = "Organization Prefix.  Using your initials or a 4 letter identifier is probably best."
  type = "string"
}

variable "cost-center" {
  description = "A cost center tag"
  default = "nebulosus"
}

#############################
# Locations
#############################
variable "region" {
  description = "Regional Target"
  type = "string"
  default = "us-west-2"
}

variable "azs" {
  description = "Availability Zone"
  type = "list"
  default = ["a","b","c"]
}

#############################
# Instance Sizing & Counts
#############################
variable "min-count" {
  description = "Minimum number of instances to attach to the ASG"
  default = 2
}

variable "max-count" {
  description = "Maximum number of instances to attach to the ASG"
  default = 3
}

variable "instance-type" {
  description = "Instance type to use for the primary nodes."
  default = "t3.micro"
}

variable "instance-ami" {
  description = "AMI instance to use"
  default = "ami-a0cfeed8" #https://aws.amazon.com/amazon-linux-ami/ current for us-west-2
}

variable "key-name" {
  description = "Name of the key pair to be attached to this instance"
}

variable "sg-public-ssh" {
  description = "Set to 0 to disable the default SSH ingress rule from all hosts."
  default = 1
}

############################################################
# Outputs
############################################################

#############################
# Security Group
#############################
output "sg-id" {
  value = "${aws_security_group.instance-group.id}"
}

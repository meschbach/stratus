########################################################################################################################
# Example Application of Nebulosus
#
# Complete Example
########################################################################################################################

############################################################
# Resources
############################################################

#############################
# Key Pair
#############################
# This will create the public key allowing you to access your new nodes
resource "aws_key_pair" "example-key" {
  key_name = "example-key"
  public_key = "${file("ssh-key.pub")}"
}

#############################
# Apply the module
#############################
module "nebulosus" {
  source = "../nebulosus"
  org-prefix = "mee-test"
  key-name = "${aws_key_pair.example-key.key_name}"
}

############################################################
# Provider Configuration
############################################################
provider "aws" {
  version = "2.7"
  region = "us-west-2"
}

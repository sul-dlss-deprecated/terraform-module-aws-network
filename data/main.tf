#######################################################################
# VPC itself
#######################################################################

data "aws_availability_zones" "available" {}

data "aws_vpc" "selected" {
  cidr_block = "10.0.0.0/16"

  filter {
    name   = "tag:Name"
    values = ["${var.environment}"]
  }
}

locals {
  public_subnets       = ["10.0.0.0/24",   "10.0.1.0/24",   "10.0.2.0/24"]
  private_subnets      = ["10.0.64.0/24",  "10.0.65.0/24",  "10.0.66.0/24"]
  database_subnets     = ["10.0.128.0/24", "10.0.129.0/24", "10.0.130.0/24"]
}

#  azs      = ["${data.aws_availability_zones.available.names[0]}",
#              "${data.aws_availability_zones.available.names[1]}",
#              "${data.aws_availability_zones.available.names[2]}"]

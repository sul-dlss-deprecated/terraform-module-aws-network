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

data "aws_subnet" "public1" {
  vpc_id     = "${data.aws_vpc.selected.id}"
  cidr_block = "10.0.0.0/24"
}

data "aws_subnet" "public2" {
  vpc_id     = "${data.aws_vpc.selected.id}"
  cidr_block = "10.0.1.0/24"
}

data "aws_subnet" "public3" {
  vpc_id     = "${data.aws_vpc.selected.id}"
  cidr_block = "10.0.2.0/24"
}

data "aws_subnet" "private1" {
  vpc_id     = "${data.aws_vpc.selected.id}"
  cidr_block = "10.0.64.0/24"
}

data "aws_subnet" "private2" {
  vpc_id     = "${data.aws_vpc.selected.id}"
  cidr_block = "10.0.65.0/24"
}

data "aws_subnet" "private3" {
  vpc_id     = "${data.aws_vpc.selected.id}"
  cidr_block = "10.0.66.0/24"
}

data "aws_subnet" "db1" {
  vpc_id     = "${data.aws_vpc.selected.id}"
  cidr_block = "10.0.128.0/24"
}

data "aws_subnet" "db2" {
  vpc_id     = "${data.aws_vpc.selected.id}"
  cidr_block = "10.0.129.0/24"
}

data "aws_subnet" "db3" {
  vpc_id     = "${data.aws_vpc.selected.id}"
  cidr_block = "10.0.130.0/24"
}


locals {
  public_subnets   = [
                      "${data.aws_subnet.public1.id}",
                      "${data.aws_subnet.public2.id}",
                      "${data.aws_subnet.public3.id}",
                     ]
  private_subnets  = [
                      "${data.aws_subnet.private1.id}",
                      "${data.aws_subnet.private2.id}",
                      "${data.aws_subnet.private3.id}",
                     ]
  database_subnets = [
                      "${data.aws_subnet.db1.id}",
                      "${data.aws_subnet.db2.id}",
                      "${data.aws_subnet.db3.id}",
                     ]
}

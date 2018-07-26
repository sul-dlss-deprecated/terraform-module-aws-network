#######################################################################
# VPC itself
#######################################################################

data "aws_availability_zones" "available" {}

module "vpc" {
  name = "${var.environment}"
  source  = "terraform-aws-modules/vpc/aws"
  version = "1.28.0"

  cidr                 = "10.0.0.0/16"
  public_subnets       = ["10.0.0.0/24",   "10.0.1.0/24",   "10.0.2.0/24"]
  private_subnets      = ["10.0.64.0/24",  "10.0.65.0/24",  "10.0.66.0/24"]
  database_subnets     = ["10.0.128.0/24", "10.0.129.0/24", "10.0.130.0/24"]
  elasticache_subnets  = ["10.0.192.0/24", "10.0.193.0/24", "10.0.194.0/24"]

  enable_dns_support   = "true"
  enable_dns_hostnames = "true"
  enable_nat_gateway   = "true"
  single_nat_gateway   = "true"

  azs      = ["${data.aws_availability_zones.available.names[0]}",
              "${data.aws_availability_zones.available.names[1]}",
              "${data.aws_availability_zones.available.names[2]}"]

  tags {
    "Terraform" = "true"
    "Environment" = "${var.environment}"
  }
}

#######################################################################
# Endpoints to private networks
#######################################################################

# s3
data "aws_vpc_endpoint_service" "s3" {
  count = "${var.enable_s3_endpoint ? 1 : 0}"

  service = "s3"
}

resource "aws_vpc_endpoint" "s3" {
  count = "${var.enable_s3_endpoint ? 1 : 0}"

  vpc_id       = "${module.vpc.vpc_id}"
  service_name = "${data.aws_vpc_endpoint_service.s3.service_name}"
}

resource "aws_vpc_endpoint_route_table_association" "private_s3" {
  count = "${var.enable_s3_endpoint ? length(module.vpc.private_subnets) : 0}"

  vpc_endpoint_id = "${aws_vpc_endpoint.s3.id}"
  route_table_id  = "${element(module.vpc.private_route_table_ids, count.index)}"
}

# dynamodb
data "aws_vpc_endpoint_service" "dynamodb" {
  count = "${var.enable_dynamodb_endpoint ? 1 : 0}"

  service = "dynamodb"
}

resource "aws_vpc_endpoint" "dynamodb" {
  count = "${var.enable_dynamodb_endpoint ? 1 : 0}"

  vpc_id       = "${module.vpc.vpc_id}"
  service_name = "${data.aws_vpc_endpoint_service.dynamodb.service_name}"
}

resource "aws_vpc_endpoint_route_table_association" "private_dynamodb" {
  count = "${var.enable_dynamodb_endpoint ? length(module.vpc.private_subnets) : 0}"

  vpc_endpoint_id = "${aws_vpc_endpoint.dynamodb.id}"
  route_table_id  = "${element(module.vpc.private_route_table_ids, count.index)}"
}

# create a kinesis endpoint service for the private subnets
data "aws_vpc_endpoint_service" "kinesis" {
  count = "${var.enable_kinesis_endpoint ? 1 : 0}"

  service = "kinesis-streams"
}

resource "aws_vpc_endpoint" "kinesis" {
  count = "${var.enable_kinesis_endpoint ? 1 : 0}"

  vpc_id              = "${module.vpc.vpc_id}"
  service_name        = "${data.aws_vpc_endpoint_service.kinesis.service_name}"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = ["${element(module.vpc.private_subnets, 0)}"]

  security_group_ids = ["${aws_security_group.interface_endpoint.id}"]
}

resource "aws_security_group" "interface_endpoint" {
  count = "${var.enable_kinesis_endpoint ? 1 : 0}"

  name        = "${var.environment}_interface_endpoint"
  vpc_id      = "${module.vpc.vpc_id}"

  ingress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["10.0.0.0/16"]
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Environment   = "${var.environment}"
  }
}

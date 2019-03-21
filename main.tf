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
  count = "${var.enable_s3_endpoint ? 3 : 0}"

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
  count = "${var.enable_dynamodb_endpoint ? 3 : 0}"

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

// Save output variables to SSM Parameters for use outside of the module
resource "aws_ssm_parameter" "vpc_id" {
  name        = "vpc_id"
  type        = "String"
  value       = "${module.vpc.vpc_id}"
  description = "The ID for this organizations VPC"
  overwrite   = true

  tags {
    "Environment" = "${var.environment}"
    "Terraform"   = "true"
  }
}

resource "aws_ssm_parameter" "public_subnets" {
  name        = "public_subnets"
  type        = "StringList"
  value       = "${module.vpc.public_subnets}"
  description = "List of the public subnets in the VPC"
  overwrite   = true

  tags {
    "Environment" = "${var.environment}"
    "Terraform"   = "true"
  }
}

resource "aws_ssm_parameter" "private_subnets" {
  name        = "private_subnets"
  type        = "StringList"
  value       = "${module.vpc.private_subnets}"
  description = "List of the private subnets in the VPC"
  overwrite   = true

  tags {
    "Environment" = "${var.environment}"
    "Terraform"   = "true"
  }
}

resource "aws_ssm_parameter" "database_subnets" {
  name        = "database_subnets"
  type        = "StringList"
  value       = "${module.vpc.database_subnets}"
  description = "List of the database subnets in the VPC"
  overwrite   = true

  tags {
    "Environment" = "${var.environment}"
    "Terraform"   = "true"
  }
}

resource "aws_ssm_parameter" "elasticache_subnets" {
  name        = "elasticache_subnets"
  type        = "StringList"
  value       = "${local.elasticache_subnets}"
  description = "List of the elasticache subnets in the VPC"
  overwrite   = true

  tags {
    "Environment" = "${var.environment}"
    "Terraform"   = "true"
  }
}

resource "aws_ssm_parameter" "database_subnet_group" {
  name        = "database_subnet_group"
  type        = "String"
  value       = "${module.vpc.database_subnet_group}"
  description = "The database subnet group for the VPC"
  overwrite   = true

  tags {
    "Environment" = "${var.environment}"
    "Terraform"   = "true"
  }
}

resource "aws_ssm_parameter" "elasticache_subnet_group" {
  name        = "elasticache_subnet_group"
  type        = "String"
  value       = "${module.vpc.elasticache_subnet_group}"
  description = "The elasticache subnet group for the VPC"
  overwrite   = true

  tags {
    "Environment" = "${var.environment}"
    "Terraform"   = "true"
  }
}

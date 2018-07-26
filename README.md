# Overview

This module sets up a VPC and possible endpoints for S3, DynamoDB, and Kinesis
in the private network range.  It's in itself mostly a wrapper for the
community terraform-aws-modules/vpc/aws module, filling that out with the
subnets and other configuration options that we choose to use.

# Variables

See variables.tf for all current variables and descriptions.

# Resources

- terraform-aws-modules/vpc/aws
- aws_vpc_endpoint (s3)
  - aws_vpc_endpoint_route_table_association
- aws_vpc_endpoint (dynamodb)
  - aws_vpc_endpoint_route_table_association
- aws_vpc_endpoint (kinesis)
  - aws_security_group

# Outputs

See output.tf for all current outputs.

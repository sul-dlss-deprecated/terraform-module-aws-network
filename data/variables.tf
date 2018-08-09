variable "environment" {
  description = "Environment, used to name the VPC itself and as part of the name for other resources"
}

variable "enable_s3_endpoint" {
  description = "Whether to create an S3 endpoint to the private network"
  default     = false
}

variable "enable_dynamodb_endpoint" {
  description = "Whether to create a DynamoDB endpoint to the private network"
  default     = false
}

variable "enable_kinesis_endpoint" {
  description = "Whether to create a Kinesis endpoint to the private network"
  default     = false
}

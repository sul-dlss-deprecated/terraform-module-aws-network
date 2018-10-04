output "vpc_id" {
  value = "${data.aws_vpc.selected.id}"
}

output "public_subnets" {
  value = "${join(",", local.public_subnets)}"
}

output "private_subnets" {
  value = "${join(",", local.private_subnets)}"
}

output "database_subnets" {
  value = "${join(",", local.database_subnets)}"
}

output "elasticache_subnets" {
  value = "${join(",", local.elasticache_subnets)}"
}

# There's no reader for the two subnet_group resources, but the id is the name
# and the name is set to the environment.
output "database_subnet_group" {
  value = "${var.environment}"
}

output "elasticache_subnet_group" {
  value = "${var.environment}"
}

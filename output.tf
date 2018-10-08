output "vpc_id" {
  value = "${module.vpc.vpc_id}"
}

output "public_subnets" {
  value = "${join(",", module.vpc.public_subnets)}"
}

output "private_subnets" {
  value = "${join(",", module.vpc.private_subnets)}"
}

output "database_subnets" {
  value = "${join(",", module.vpc.database_subnets)}"
}

output "elasticache_subnets" {
  value = "${join(",", local.elasticache_subnets)}"
}

output "database_subnet_group" {
  value = "${module.vpc.database_subnet_group}"
}

output "elasticache_subnet_group" {
  value = "${module.vpc.elasticache_subnet_group}"
}

# v6

* Deprecated `//data` outputs that joined strings w/ commas, e.g. `public_subnets`
* Provided proper list outputs as replacements, e.g. `public_subnet_ids`.  

# v5

* Removed unused variables from `//data`.
* Add elasticache subnets to outputs in both main and data modules.

# v4

* `data`: Change the subnets from a list of cidr blocks to a list of subnet ids.

# v3

* Added in a data sub-module that takes the same arguments, but only returns an
  existing VPC's variables in output.  This is meant to be used in situations
  where you have a separate state file in the same account as a VPC resource
  that's already been set up, to use that VPC as a data source.

# v2

* Hardcoded subnet counts to work around terraform problem.

# v1

* First release

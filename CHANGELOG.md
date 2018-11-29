# v3

* Removed unused variables from `//data`.

# v2

* Added in a data sub-module that takes the same arguments, but only returns an
  existing VPC's variables in output.  This is meant to be used in situations
  where you have a separate state file in the same account as a VPC resource
  that's already been set up, to use that VPC as a data source.

# v1

* First release

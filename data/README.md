# Overview

This module is a representation of the VPC module in the parent directory, but
one which only loads values as a data source.  The intent is to make it easier
for us to have people include this version of the module when they wish to
work against an existing shared VPC in development, then not have to make major
changes to multiple places that are including data from the module.  Doing as a
bare data source means having to potentially update a number of variables for
subnets when you move over.

This should be kept in sync with any changes to the parent directory's inputs
and outputs.

# Variables

See variables.tf for all current variables and descriptions.

# Resources

This only uses local variables and data sources needed to mimic the parent
directory.

# Outputs

See output.tf for all current outputs.

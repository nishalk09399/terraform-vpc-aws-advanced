data "aws_availability_zones" "available" {
  state = "available"
}

# output "azs" { # we are writing this in locals.tf as a slice function
#     value = data.aws_availability_zones.available.names # to get the direct names
# }
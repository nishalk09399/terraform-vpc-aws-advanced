locals {
    azs = slice(data.aws_availability_zones.available.names,0,2)  #0 is inclusive and 2 is exclusive it will give 0 and 1


}

# output "azs" {
#     value = local.azs
# }
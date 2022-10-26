
#  variable "vpc_enabled" {
#    description = "Controls if VPC should be created (it affects almost all resources)"
#    type        = bool
#    default = true
#  }



# variable "tfc_vpc_object" {
#   type = map(object({
#     cidr_vpc  = string,
#     vpc_name = string,
#     instance-tenancy = string,
#     enable-dns-support = bool,
#     enable-dns-hostnames  = bool,
#      secondcidr_vpc  = string,
#   }))
# }

# variable "tfc_subnet_object" {
#   type = map(object({
#     vpc-private-subnet-cidr = string, 
#     vpc-infra-subnet-cidr = string,
#     private_subnet_name = string,
#     infra-subnets = string,
#     availability_zone = string,
#     pvt-route-name = string ,
#     infra-route-name = string
#   }))
# }



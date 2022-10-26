# # # Creating VPC.

# locals {
#   vpc_obj = flatten(
#    [
#      for k in aws_vpc.vpc: [
#            {
#               vpc_id = k.id
#            }
#      ]
#    ]
#  )
# }

# # Creating VPC.vpc
# resource "aws_vpc" "vpc" {
#   for_each  =   { for k, v in var.tfc_vpc_object : k => v if var.vpc_enabled}
#   cidr_block           = "${each.value.cidr_vpc}"
#   instance_tenancy     = "${each.value.instance-tenancy}"
#   enable_dns_support   = "${each.value.enable-dns-support}"
#   enable_dns_hostnames = "${each.value.enable-dns-hostnames}"
       
#   tags = {
#     Name = "${each.value.vpc_name}"
#   }
# }
# # Creating Secondary CIDR Blocks to VPC

# resource "aws_vpc_ipv4_cidr_block_association" "secondary_cidr" {
#   for_each  =   { for k, v in var.tfc_vpc_object : k => v if var.vpc_enabled}
#   vpc_id = "${local.vpc_obj[0].vpc_id}"
#   cidr_block = "${each.value.secondcidr_vpc}"
  

# }


# resource "aws_subnet" "private-subnet" {
#   for_each  =   { for k, v in var.tfc_subnet_object : k => v if var.vpc_enabled}
#   availability_zone = "${each.value.availability_zone}"
#   cidr_block        = "${each.value.vpc-private-subnet-cidr}"
#   vpc_id            = "${local.vpc_obj[0].vpc_id}"
#   map_public_ip_on_launch = false

#   tags = {
#     "Name" = "${each.value.private_subnet_name}"
#   }
# }


# # Creating Infra Subnets

# resource "aws_subnet" "Infra" {
#   for_each  =   { for k, v in var.tfc_subnet_object : k => v if var.vpc_enabled}
#   availability_zone = "${each.value.availability_zone}"
#   cidr_block        = "${each.value.vpc-infra-subnet-cidr}"                  
#   vpc_id            = "${local.vpc_obj[0].vpc_id}"
#   map_public_ip_on_launch = false



#   tags = {
#     "Name" = "${each.value.infra-subnets}"
#   }
  
   
# }














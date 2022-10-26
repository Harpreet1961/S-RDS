# locals {
#   ingress_rules = [{
#     port = 443
#     description =" Allow HTTPS"
#     protocol = "tcp"

#     },

#     {
#       port = 22
#       description =" Allow SSH"
#        protocol = "tcp"
#     },

#     {
#       port = -1
#       description =" Allow ICMP"
#        protocol = "icmp"

#     },

#     {

#       port = 5432
#       description =" Allow PSQL"
#        protocol = "tcp"


#     },

#     {

#       port = 5433
#       description =" Allow PSQL"
#        protocol = "tcp"


#     }

    
    
    
#     ]
# }

# resource "aws_security_group" "my_sg" {
#   vpc_id = var.vpc_id
  

# dynamic "ingress" {
#   for_each = local.ingress_rules

#   content {
#     description = ingress.value.description
#     protocol = ingress.value.protocol
#     to_port = ingress.value.port
#     self = false 
#     from_port =ingress.value.port
#     cidr_blocks = [var.cidr_vpc]

#   }
# }

# egress {
#     from_port   = -1
#     to_port     = -1
#     protocol    = "icmp"
#     self        = false
#     cidr_blocks = [var.cidr_vpc]
#     description = "Allow ICMP IPv4"
#   }

#   tags = {
#     "Name" = var.sg_name
#       }


# }






# # resource "aws_security_group" "my_sg" {
# #   vpc_id = var.vpc_id
# #     ingress {
# #     protocol  = "icmp"
# #     self      = false
# #     from_port = -1
# #     to_port   = -1
# #     cidr_blocks = [var.cidr_tgw,var.cidr_vpc]
# #     description = "Allow ICMP"
# #   }
# #   ingress {
# #     protocol  = "tcp"
# #     self      = false
# #     from_port = 22
# #     to_port   = 22
# #     cidr_blocks = [var.cidr_tgw,var.cidr_vpc]
# #     description = "Allow SSH"
# #   }
# #   ingress {
# #     protocol  = "tcp"
# #     self      = false
# #     from_port = 443
# #     to_port   = 443
# #     cidr_blocks = [var.cidr_tgw,var.cidr_vpc]
# #     description = "Allow HTTPS"
# #   }
  
# #   egress {
# #     from_port   = -1
# #     to_port     = -1
# #     protocol    = "icmp"
# #     self        = false
# #     cidr_blocks = [var.cidr_tgw,var.cidr_vpc]
# #     description = "Allow ICMP IPv4"
# #   }

# #   tags = {
# #     "Name" = var.sg_name
# #       }
# # }



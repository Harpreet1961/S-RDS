# Defining provider
provider "aws" {
  region  = var.aws_region
  profile = "tf-user"
  version = "~> 3.12"
}

terraform {
  backend "s3" {
    
    profile = "tf-user"
  }
}


# VPC Module
module "tfc-connect-vpc" {
  source            = "git::https://github.com/Harpreet1961/harpreet.git"
  tfc_vpc_object     = var.tfc_vpc_object
   tfc_subnet_object  = var.tfc_subnet_object
  flow-log-role-name  = "vpc-cloudwatch-role"
  flow-log           = var.flow-log
  cloudwatch-logs-name = "test-cloudwatch-logs"
  tgw-attachment-name = "tgw-attachment"
  sg_name = "sg-vpc"
   tfc_tgw_object =  var.tfc_tgw_object
   service-name = "s3"
  service-type = "Interface"
  vpc-endpoint-type = "Interface"
  port = "5432"
  protocol = "tcp"
  description = "Allo PSQL"
    
}




data "aws_vpc" "vpc_id" {
  depends_on = [
    module.tfc-connect-vpc
  ]


  filter {
    name   = "tag:Name"
    values = ["*test*", "*test1*"]
  }
}


data "aws_subnet_ids" "subnet-ids" {

  vpc_id = data.aws_vpc.vpc_id.id

  filter {
    name   = "tag:Name"
    values = ["*private*", "*private1*"]
  }


}

data "aws_security_group" "sg" {

  depends_on = [
    module.tfc-connect-vpc
  ]
  filter {
    name   = "tag:Name"
    values = ["*sg*", "*sg1*"]
  }

}

resource "aws_db_subnet_group" "default" {

  subnet_ids = data.aws_subnet_ids.subnet-ids.ids



}

module "postgresql_rds" {
  source                 = "./modules/rds-baseline"
  vpc_id                 = data.aws_vpc.vpc_id.id
  tfc_rds_object         = var.tfc_rds_object
  vpc_security_group_ids = data.aws_security_group.sg.id
  subnet_group           = aws_db_subnet_group.default.name
  cloudwatch_logs_exports = ["postgresql"]

}

data "aws_db_instance" "rds_id" {
  db_instance_identifier = "rds"
  depends_on = [
    module.postgresql_rds
  ]

}

resource "aws_sns_topic" "default" {
  name_prefix = "my-premade-topic"
}







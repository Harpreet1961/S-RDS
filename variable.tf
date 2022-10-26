

variable "aws_region" {
  type        = string
  default     = "us-west-2"
  description = "AWS region for deployments"
}


variable "tfc_vpc_object" {
  type = map(object({
    cidr_vpc  = string,
    vpc_name = string,
    instance-tenancy = string,
    enable-dns-support = bool,
    enable-dns-hostnames  = bool
    secondcidr_vpc  = string,
   
  }))
}

variable "tfc_subnet_object" {
  type = map(object({
    vpc-private-subnet-cidr = string, 
    vpc-infra-subnet-cidr = string,
    private_subnet_name = string,
    infra-subnets = string,
    availability_zone = string,
     pvt-route-name = string ,
    infra-route-name = string
  }))
}

 variable "flow-log" {
  type = string
}
variable "tfc_tgw_object" {
  type = map(object({
    transit_subnets = string,
    transit-name = string,
    transit-routes = string,
    availability_zone = string
  }))
}


variable "tfc_rds_object" {
  type = map(object({
    project                    = string,
    environment                = string,
    allocated_storage          = number,
    engine_version             = string,
    instance_type              = string,
    storage_type               = string,
    iops                       = number,
    database_identifier        = string,
    snapshot_identifier        = string,
    database_name              = string,
    database_username          = string,
    database_port              = number,
    backup_retention_period    = number,
    backup_window              = string,
    maintenance_window         = string,
    auto_minor_version_upgrade = bool,
    final_snapshot_identifier  = string,
    skip_final_snapshot        = bool,
    copy_tags_to_snapshot      = bool,
    storage_encrypted   = bool,
    deletion_protection = bool,
    evaluation_period = number,
    statistic_period = number,
    cpu_utilization_too_high_threshold = number,
    cpu_credit_balance_too_low_threshold = number,
    disk_queue_depth_too_high_threshold = number,
    disk_free_storage_space_too_low_threshold = number,
    disk_burst_balance_too_low_threshold = number,
    memory_freeable_too_low_threshold = number,
    memory_swap_usage_too_high_threshold = number,
    anomaly_band_width = string,
    anomaly_period = string,
    maximum_used_transaction_ids_too_high_threshold = number
 

  }))
}




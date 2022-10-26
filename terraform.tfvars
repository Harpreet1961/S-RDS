# # Define Variables


tfc_vpc_object = {
  "vpc_object" = {
    cidr_vpc  = "10.142.53.0/24"
    instance-tenancy = "default"
    vpc_name = "test-vpc"
    enable-dns-support = true
    enable-dns-hostnames  = true
    secondcidr_vpc  = "172.0.0.0/16"
 
  }
}




tfc_subnet_object = {
  "primary_subnet_object" = {
    vpc-private-subnet-cidr = "10.142.53.64/28"
    vpc-infra-subnet-cidr = "10.142.53.112/28"
    private_subnet_name = "demo-private-subnet1"
    availability_zone = "us-west-2a"
    infra-subnets = "Infra-Demo1"   
     pvt-route-name = "pvt-route-table1",
    infra-route-name = "infra-route-table1" 
  },
  "secondary_subnet_object" = {
    vpc-private-subnet-cidr = "10.142.53.80/28"
    vpc-infra-subnet-cidr = "10.142.53.128/28"
    private_subnet_name = "demo-private-subnet3"
    availability_zone = "us-west-2b"
    infra-subnets = "Infra-Demo3"  
     pvt-route-name ="pvt-route-table3",
    infra-route-name ="infra-route-table3" 
  }
  
  
}

tfc_tgw_object = {
    "transit_subnets_object" ={
    transit-name = "tgw-subnet1"
    transit_subnets = "10.142.53.16/28"
    transit-routes = "transit-route-table1"
    availability_zone = "us-west-2b"
   
  },
    "transit_sec_subnets_object" ={
    transit-name = "tgw-subnet2"
    transit_subnets = "10.142.53.32/28"
    transit-routes = "transit-route-table2"
    availability_zone = "us-west-2c"

}

}

flow-log = "test-vpc-flow-logs"


tfc_rds_object = {
  "primary_database" = {
    project                    = "Something1",
    environment                = "Staging",
    allocated_storage          = "32",
    engine_version             = "13.4",
    instance_type              = "db.t3.micro",
    storage_type               = "gp2",
    iops                       = "0",
    database_identifier        = "rds",
    snapshot_identifier        = "",
    database_name              = "hector",
    database_username          = "hector",
    database_port              = "5432",
    backup_retention_period    = "30",
    backup_window              = "04:00-04:30",
    maintenance_window         = "sun:04:30-sun:05:30",
    auto_minor_version_upgrade = false,
    final_snapshot_identifier  = "terraform-aws-postgresql-rds-snapshot",
    skip_final_snapshot        = true,
    copy_tags_to_snapshot      = false,
    storage_encrypted   = true,
    deletion_protection = true,
    evaluation_period                               = "5",
    statistic_period                                = "60",
    cpu_credit_balance_too_low_threshold            = "100",
    cpu_utilization_too_high_threshold              = "75",
    disk_queue_depth_too_high_threshold             = "10"
    disk_free_storage_space_too_low_threshold       = "10000000000" // 10GB
    disk_burst_balance_too_low_threshold            = "100"
    memory_freeable_too_low_threshold               = "256000000" // 256 MB,
    memory_swap_usage_too_high_threshold            = "256000000" // 256 MB
    anomaly_band_width                              = "2"
    anomaly_period                                  = "600"
    maximum_used_transaction_ids_too_high_threshold = "1000000000" // 1 billion. Half of total
 
  }
}

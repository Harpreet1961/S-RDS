
variable "vpc_security_group_ids" {
   
}


variable "tfc_rds_object" {
  type = map(object({
    project  = string,
    environment = string,
    allocated_storage = number,
    engine_version = string,
    instance_type  = string,
    storage_type  = string,
    iops  =   number,
    database_identifier = string,
    snapshot_identifier = string,
    database_name = string,
    database_username = string,
    database_port = number,
    backup_retention_period = number,
    backup_window = string,
    maintenance_window = string,
    auto_minor_version_upgrade = bool,
    final_snapshot_identifier = string,
    skip_final_snapshot = bool,
    copy_tags_to_snapshot = bool,
    storage_encrypted = bool,
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
    anomaly_band_width = string
    anomaly_period = string
    maximum_used_transaction_ids_too_high_threshold = number
  
  }))
}

variable "actions_alarm" {
  type        = list
  default     = []
  description = "A list of actions to take when alarms are triggered. Will likely be an SNS topic for event distribution."
}


variable "vpc_id" {
  type        = string
  description = "ID of VPC meant to house database"
}

variable "cloudwatch_logs_exports" {
  default     = ["postgresql", "upgrade"]
  type        = list
  description = "List of logs to publish to CloudWatch Logs"
}

variable "subnet_group" {
  type        = string
  description = "Database subnet group"
}

variable "create_low_cpu_credit_alarm" {
  type        = bool
  default     = true
  description = "Whether or not to create the low cpu credit alarm.  Default is to create it (for backwards compatible support)"
}


variable "tags" {
  default     = {}
  type        = map(string)
  description = "Extra tags to attach to the RDS resources"
}


variable "create_cloudwatch_log_group" {
  type = bool
  default = true
  
}
variable "cloudwatch_log_group_retention_in_days" {
  description = "The number of days to retain CloudWatch logs for the DB instance"
  type        = number
  default     = 7
}

variable "cloudwatch_log_group_kms_key_id" {
  description = "The ARN of the KMS Key to use when encrypting log data"
  type        = string
  default     = null
}



variable "create_high_cpu_alarm" {
    type = bool
    default = true
  
}

variable "create_high_queue_depth_alarm" {
    type = bool
    default = true
  
}

variable "create_low_disk_space_alarm" {
    type = bool
    default = true
  
}

variable "create_low_disk_burst_alarm" {
    type = bool
    default = true  
}

variable "create_low_memory_alarm" {
    type = bool
    default = true
  
}

variable "create_swap_alarm" {
    type = bool
    default = true
  
}

variable "create_anomaly_alarm" {
    type = bool
    default = true
  
}
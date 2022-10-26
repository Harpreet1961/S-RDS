resource "random_password" "this_rds_random_string"{
  length           = 16
  special          = false
}

resource "aws_secretsmanager_secret" "this_rds_random_password" {
  name = "rds-psql-master-db-secrettt412"
}

resource "aws_secretsmanager_secret_version" "this_secret_password" {
  secret_id = aws_secretsmanager_secret.this_rds_random_password.id
  secret_string = random_password.this_rds_random_string.result
}


resource "aws_kms_key" "kms" {
 for_each =  var.tfc_rds_object

  tags = merge(
    {
      Name        = "DatabaseServer",
      Project     = "${each.value.project}",
      Environment = "${each.value.environment}"
    },
    var.tags
  )
}


resource "aws_db_instance" "postgresql" {

  for_each =  var.tfc_rds_object
  allocated_storage               = "${each.value.allocated_storage}"
  engine                          = "postgres"
  engine_version                  = "${each.value.engine_version}"
  identifier                      = "${each.value.database_identifier}"
  snapshot_identifier             ="${each.value.snapshot_identifier}"
  instance_class                  = "${each.value.instance_type}"
  storage_type                    ="${each.value.storage_type}"
  iops                            = "${each.value.iops}"
  name                            = "${each.value.database_name}"
  password                        = aws_secretsmanager_secret_version.this_secret_password.secret_string
  username                        = "${each.value.database_username}"
  backup_retention_period         = "${each.value.backup_retention_period}"
  backup_window                   = "${each.value.backup_window}"
  maintenance_window              = "${each.value.maintenance_window}"
  auto_minor_version_upgrade      = "${each.value.auto_minor_version_upgrade}"
  final_snapshot_identifier       = "${each.value.final_snapshot_identifier}"
  skip_final_snapshot             = "${each.value.skip_final_snapshot}"
  copy_tags_to_snapshot           = "${each.value.copy_tags_to_snapshot}"
  multi_az                        =   "${each.value.environment}" == "dev" ? true : false
  port                            = "${each.value.database_port}"
   vpc_security_group_ids          =  ["${var.vpc_security_group_ids}"]
  db_subnet_group_name            = "${var.subnet_group}"
 # parameter_group_name            = var.parameter_group
  storage_encrypted               = "${each.value.storage_encrypted}"
   kms_key_id                      = aws_kms_key.kms[each.key].arn
   enabled_cloudwatch_logs_exports = var.cloudwatch_logs_exports

  tags = merge(
    {
      Name        = "DatabaseServer",
      Project     = "${each.value.project}",
      Environment = "${each.value.environment}"
    },
    var.tags
  )
  depends_on = [
    aws_secretsmanager_secret_version.this_secret_password
  ]
}

resource "aws_cloudwatch_log_group" "this" {
  for_each = {for k, v in var.tfc_rds_object : k => v if var.create_cloudwatch_log_group }

  name              = "/aws/rds/instance1/${each.value.database_identifier}"
  retention_in_days = var.cloudwatch_log_group_retention_in_days
  kms_key_id        = var.cloudwatch_log_group_kms_key_id

  tags = var.tags
}


#CloudWatch resources

// CPU Utilization

resource "aws_cloudwatch_metric_alarm" "cpu_utilization_too_high" {
  for_each = { for k, v in var.tfc_rds_object : k => v if var.create_high_cpu_alarm }
  alarm_name = "alarm${each.value.environment}DatabaseServerCPUUtilization-${each.value.database_identifier}"
  alarm_description = "Database server CPU utilization"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods = "${each.value.evaluation_period}"
  metric_name = "CPUUtilization"
  namespace = "AWS/RDS"
  period = "300"
  statistic = "Average"
  threshold = "${each.value.cpu_utilization_too_high_threshold}"
  alarm_actions       = var.actions_alarm
   # ok_actions          = var.actions_ok
  

  dimensions = {
    DBInstanceIdentifier = aws_db_instance.postgresql[each.key].id
  }
 
  
}


resource "aws_cloudwatch_metric_alarm" "cpu_credit_balance_too_low" {
  for_each  =   { for k, v in var.tfc_rds_object : k => v if var.create_low_cpu_credit_alarm  }
  alarm_name = "alarm${each.value.environment}DatabaseServerCPUUtilization-${each.value.database_identifier}"
  alarm_description = "Database server CPU utilization"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods = "${each.value.evaluation_period}"
  metric_name = "CPUUtilization"
  namespace = "AWS/RDS"
  period = "300"
  statistic = "Average"
  threshold = "${each.value.cpu_credit_balance_too_low_threshold}"
  alarm_actions       = var.actions_alarm
   # ok_actions          = var.actions_ok
  

  dimensions = {
    DBInstanceIdentifier = aws_db_instance.postgresql[each.key].id
  }
 
  
}

// Disk Utilization
resource "aws_cloudwatch_metric_alarm" "disk_queue_depth_too_high" {
    for_each = { for k, v in var.tfc_rds_object : k => v if var.create_high_queue_depth_alarm }
    
    #   for_each  =   { for k, v in var.tfc_vpc_object : k => v if var.vpc_enabled}

    alarm_name          = "alarm${each.value.environment}highDiskQueueDepth-${each.value.database_identifier}"
    comparison_operator = "GreaterThanThreshold"
    evaluation_periods  = "${each.value.evaluation_period}"
    metric_name         = "DiskQueueDepth"
    namespace           = "AWS/RDS"
    period              = "${each.value.statistic_period}"
    statistic           = "Average"
    threshold           = "${each.value.disk_queue_depth_too_high_threshold}"
    alarm_description   = "Average database disk queue depth is too high, performance may be negatively impacted."
    alarm_actions       = var.actions_alarm
 # ok_actions          = var.actions_ok

  dimensions = {
    DBInstanceIdentifier = aws_db_instance.postgresql[each.key].id
  }
  tags = var.tags
}

resource "aws_cloudwatch_metric_alarm" "disk_free_storage_space_too_low" {
    for_each = { for k, v in var.tfc_rds_object : k => v if var.create_low_disk_space_alarm }
    alarm_name          = "alarm${each.value.environment}lowFreeStorageSpace-${each.value.database_identifier}"
    comparison_operator = "LessThanThreshold"
    evaluation_periods  = "${each.value.evaluation_period}"
    metric_name         = "FreeStorageSpace"
    namespace           = "AWS/RDS"
    period              = "${each.value.statistic_period}"
    statistic           = "Average"
    threshold           = "${each.value.disk_free_storage_space_too_low_threshold}"
    alarm_description   = "Average database free storage space is too low and may fill up soon."
    alarm_actions       = var.actions_alarm
  #  ok_actions          = var.actions_ok

  dimensions = {
    DBInstanceIdentifier = aws_db_instance.postgresql[each.key].id
  }
  tags = var.tags
}

resource "aws_cloudwatch_metric_alarm" "disk_burst_balance_too_low" {
    for_each = {for k , v in var.tfc_rds_object : k => v if var.create_low_disk_burst_alarm }
 # count               = var.create_low_disk_burst_alarm ? 1 : 0
   alarm_name          = "alarm${each.value.environment}lowEBSBurstBalance-${each.value.database_identifier}"
   comparison_operator = "LessThanThreshold"
   evaluation_periods  = "${each.value.evaluation_period}"
   metric_name         = "BurstBalance"
   namespace           = "AWS/RDS"
   period              = "${each.value.statistic_period}"
   statistic           = "Average"
   threshold           = "${each.value.disk_burst_balance_too_low_threshold}"
   alarm_description   = "Average database storage burst balance is too low, a negative performance impact is imminent."
   alarm_actions       = var.actions_alarm
  # ok_actions          = var.actions_ok

  dimensions = {
    DBInstanceIdentifier = aws_db_instance.postgresql[each.key].id
  }
  tags = var.tags
}


// Memory Utilization
resource "aws_cloudwatch_metric_alarm" "memory_freeable_too_low" {
    for_each = {for k, v in var.tfc_rds_object : k => v if var.create_low_memory_alarm }
    alarm_name          = "alarm${each.value.environment}lowFreeableMemory-${each.value.database_identifier}"
    comparison_operator = "LessThanThreshold"
    evaluation_periods  = "${each.value.evaluation_period}"
    metric_name         = "FreeableMemory"
    namespace           = "AWS/RDS"
    period              = "${each.value.statistic_period}"
    statistic           = "Average"
    threshold           = "${each.value.memory_freeable_too_low_threshold}"
    alarm_description   = "Average database freeable memory is too low, performance may be negatively impacted."
    alarm_actions       = var.actions_alarm
  #  ok_actions          = var.actions_ok

  dimensions = {
    DBInstanceIdentifier = aws_db_instance.postgresql[each.key].id
  }
  tags = var.tags
}

resource "aws_cloudwatch_metric_alarm" "memory_swap_usage_too_high" {
    for_each = {for k, v in var.tfc_rds_object : k => v if var.create_swap_alarm }
    alarm_name          = "alarm${each.value.environment}highSwapUsage-${each.value.database_identifier}"
    comparison_operator = "GreaterThanThreshold"
    evaluation_periods  = "${each.value.evaluation_period}"
    metric_name         = "SwapUsage"
    namespace           = "AWS/RDS"
    period              = "${each.value.statistic_period}"
    statistic           = "Average"
    threshold           = "${each.value.memory_swap_usage_too_high_threshold}"
    alarm_description   = "Average database swap usage is too high, performance may be negatively impacted."
    alarm_actions       = var.actions_alarm
 # ok_actions          = var.actions_ok

  dimensions = {
    DBInstanceIdentifier =  aws_db_instance.postgresql[each.key].id
  }
  tags = var.tags
}


// Connection Count
resource "aws_cloudwatch_metric_alarm" "connection_count_anomalous" {
    for_each = {for k, v in var.tfc_rds_object : k => v if var.create_anomaly_alarm }
    alarm_name          = "alarm${each.value.environment}anomalousConnectionCount-${each.value.database_identifier}"
    comparison_operator = "GreaterThanUpperThreshold"
    evaluation_periods  = "${each.value.evaluation_period}"
    threshold_metric_id = "e1"
    alarm_description   = "Anomalous database connection count detected. Something unusual is happening."
    alarm_actions       = var.actions_alarm
   # ok_actions          = var.actions_ok

  metric_query {
    id          = "e1"
    expression  = "ANOMALY_DETECTION_BAND(m1, ${each.value.anomaly_band_width})"
    label       = "DatabaseConnections (Expected)"
    return_data = "true"
  }

  metric_query {
    id          = "m1"
    return_data = "true"
    metric {
      metric_name = "DatabaseConnections"
      namespace   = "AWS/RDS"
      period      = "${each.value.anomaly_period}"
      stat        = "Average"
      unit        = "Count"

      dimensions = {
        DBInstanceIdentifier = aws_db_instance.postgresql[each.key].id
      }
    }
  }
  tags = var.tags
}

resource "aws_cloudwatch_metric_alarm" "maximum_used_transaction_ids_too_high" {
    for_each = var.tfc_rds_object
 # count               = contains(["aurora-postgresql", "postgres"], var.engine) ? 1 : 0
    alarm_name          = "alarm${each.value.environment}maximumUsedTransactionIDs-${each.value.database_identifier}"
    comparison_operator = "GreaterThanThreshold"
    evaluation_periods  = "${each.value.evaluation_period}"
    metric_name         = "MaximumUsedTransactionIDs"
    namespace           = "AWS/RDS"
    period              = "${each.value.statistic_period}"
    statistic           = "Average"
    threshold           = "${each.value.maximum_used_transaction_ids_too_high_threshold}"
    alarm_description   = "Nearing a possible critical transaction ID wraparound."
    alarm_actions       = var.actions_alarm
  #  ok_actions          = var.actions_ok
}



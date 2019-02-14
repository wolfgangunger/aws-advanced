variable "allocated_storage" {
  description = "The allocated storage in gigabytes"
}

variable "storage_encrypted" {
  description = "Specifies whether the DB instance is encrypted"
  default     = false
}

variable "engine_version" {
  description = "The engine version to use"
}

variable "instance_class" {
  description = "The instance type of the RDS instance"
}

variable "name" {
  description = "The DB name to create. If omitted, no database is created initially"
  default     = ""
}

variable "username" {
  description = "Username for the master DB user"
}

#variable "password" {
#  description = "Password for the master DB user. Note that this may show up in logs, and it will be stored in the state file"
#}

variable "port" {
  description = "The port on which the DB accepts connections"
}

variable "final_snapshot_identifier" {
  description = "The name of your final DB snapshot when this DB instance is deleted."
  default     = false
}

variable "availability_zone" {
  description = "The Availability Zone of the RDS instance"
  default     = ""
}

variable "multi_az" {
  description = "Specifies if the RDS instance is multi-AZ"
  default     = false
}

variable "iops" {
  description = "The amount of provisioned IOPS. Setting this implies a storage_type of 'io1'"
  default     = 1000
}

variable "publicly_accessible" {
  description = "Bool to control if instance is publicly accessible"
  default     = false
}

variable "monitoring_interval" {
  description = "The interval, in seconds, between points when Enhanced Monitoring metrics are collected for the DB instance. To disable collecting Enhanced Monitoring metrics, specify 0. The default is 0. Valid Values: 0, 1, 5, 10, 15, 30, 60."
  default     = 0
}

variable "monitoring_role_arn" {
  description = "The ARN for the IAM role that permits RDS to send enhanced monitoring metrics to CloudWatch Logs. Must be specified if monitoring_interval is non-zero."
  default     = ""
}

#variable "monitoring_role_name" {
#  description = "Name of the IAM role which will be created when create_monitoring_role is enabled."
#  default     = "rds-monitoring-role"
#}

variable "allow_major_version_upgrade" {
  description = "Indicates that major version upgrades are allowed. Changing this parameter does not result in an outage and the change is asynchronously applied as soon as possible"
  default     = false
}

variable "auto_minor_version_upgrade" {
  description = "Indicates that minor engine upgrades will be applied automatically to the DB instance during the maintenance window"
  default     = true
}

variable "apply_immediately" {
  description = "Specifies whether any database modifications are applied immediately, or during the next maintenance window"
  default     = false
}

variable "maintenance_window" {
  description = "The window to perform maintenance in. Syntax: 'ddd:hh24:mi-ddd:hh24:mi'. Eg: 'Mon:00:00-Mon:03:00'"
  default = "Mon:00:00-Mon:03:00"
}

variable "skip_final_snapshot" {
  description = "Determines whether a final DB snapshot is created before the DB instance is deleted. If true is specified, no DBSnapshot is created. If false is specified, a DB snapshot is created before the DB instance is deleted, using the value from final_snapshot_identifier"
  default     = true
}

variable "copy_tags_to_snapshot" {
  description = "On delete, copy all Instance tags to the final snapshot (if final_snapshot_identifier is specified)"
  default     = false
}

variable "backup_retention_period" {
  description = "The days to retain backups for"
  default     = 1
}

variable "backup_window" {
  description = "The daily time range (in UTC) during which automated backups are created if they are enabled. Example: '09:46-10:16'. Must not overlap with maintenance_window"
  default = "03:01-05:00"
}

variable "tags" {
  description = "A mapping of tags to assign to all resources"
  default     = {}
}

variable "enabled_cloudwatch_logs_exports" {
  description = "List of log types to enable for exporting to CloudWatch logs. If omitted, no logs will be exported. Valid values (depending on engine): alert, audit, error, general, listener, slowquery, trace."
  default     = []
}

variable "deletion_protection" {
  description = "The database can't be deleted when this value is set to true."
  default     = false
}

variable "parameters" {
  default     = []
  description = "A list of DB parameters to apply. Note that parameters may differ from a family to an other. Full list of all parameters can be discovered via aws rds describe-db-parameters after initial creation of the group."
  type        = "list"
}

variable "subnet_ids" {
  description = "A list of VPC subnet IDs for the aws_db_subnet_group."
  type        = "list"
}

variable "vpc_id" {
  description = "The VPC ID of the DB's aws_security_group."
  type        = "string"
}

variable "source_security_group_svds_id" {
  description = "the security group of the SVDS instances that access the database"
  default = ""
}

variable "source_security_group_ec2_id" {
  description = "the security group of the SVDS instances that access the database"
  default = ""
}

variable "policy_file_name" {
  description = "File name of the policy for the KMS key"
  type        = "string"
}

variable "cidr_blocks" {
  description = "CIDR blocks from which the RDS instance should be accessible"
  type        = "list"
}

variable "instance_class" {
  description = "The instance type of the RDS instance"
}

variable "snapshot_identifier" {
  description = "The identifier of the snapshot to restore the database from"
}

variable "name" {
  description = "The DB name to create. If omitted, no database is created initially"
  default     = ""
}

variable "final_snapshot_identifier" {
  description = "The name of your final DB snapshot when this DB instance is deleted."
  default     = false
}

variable "skip_final_snapshot" {
  description = "Determines whether a final DB snapshot is created before the DB instance is deleted. If true is specified, no DBSnapshot is created. If false is specified, a DB snapshot is created before the DB instance is deleted, using the value from final_snapshot_identifier"
  default     = true
}

variable "copy_tags_to_snapshot" {
  description = "On delete, copy all Instance tags to the final snapshot (if final_snapshot_identifier is specified)"
  default     = false
}

variable "tags" {
  description = "A mapping of tags to assign to all resources"
  default     = {}
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

variable "cidr_blocks" {
  description = "CIDR blocks from which the RDS instance should be accessible"
  type        = "list"
}

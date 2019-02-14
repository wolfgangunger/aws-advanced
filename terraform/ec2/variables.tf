variable "name" {
  description = "Name to be used on all resources as prefix"
  type        = "string"
}

variable "count" {
  description = "Number of instances to launch"
  type        = "string"
  default     = 1
}

# vars for instances
variable "ami" {
  description = "ID of AMI to use for the instance"
  type        = "string"
}

variable "instance_type" {
  description = "The type of instance to start"
  type        = "string"
}

variable "placement_group" {
  description = "The Placement Group to start the instance in"
  type        = "string"
  default     = ""
}

variable "tenancy" {
  description = "The tenancy of the instance (if the instance is running in a VPC). Available values: default, dedicated, host."
  type        = "string"
  default     = "default"
}

variable "ebs_optimized" {
  description = "If true, the launched EC2 instance will be EBS-optimized"
  type        = "string"
  default     = false
}

variable "disable_api_termination" {
  description = "If true, enables EC2 Instance Termination Protection"
  type        = "string"
  default     = false
}

variable "instance_initiated_shutdown_behavior" {
  description = "Shutdown behavior for the instance" # https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/terminating-instances.html#Using_ChangingInstanceInitiatedShutdownBehavior
  type        = "string"
  default     = ""
}

variable "key_name" {
  description = "The key name to use for the instance"
  type        = "string"
  default     = ""
}

variable "monitoring" {
  description = "If true, the launched EC2 instance will have detailed monitoring enabled"
  type        = "string"
  default     = false
}

variable "security_group_ids" {
  description = "A list of security group IDs to associate with"
  type        = "list"
}

variable "subnet_ids" {
  description = "The VPC Subnet IDs to launch the instances in"
  type        =  "list"
}

variable "source_dest_check" {
  description = "Controls if traffic is routed to the instance when the destination address does not match the instance. Used for NAT or VPNs."
  type        = "string"
  default     = true
}

variable "iam_instance_profile" {
  description = "The IAM Instance Profile to launch the instance with. Specified as the name of the Instance Profile."
  type        = "string"
  default     = ""
}

variable "tags" {
  description = "A mapping of tags to assign to the resource"
  type        = "map"
  default     = {}
}

variable "default_tags" {
  description = "Default tags which will be applied to everything"
  type        = "map"
  default     = {
                  "Terraform" = "true"
                }
}

variable "volume_tags" {
  description = "A mapping of tags to assign to the devices created by the instance at launch time"
  type        = "map"
  default     = {}
}

variable "root_block_device" {
  description = "Customize details about the root block device of the instance"
  type        = "list"
  default     = []
}

variable "ebs_block_device" {
  description = "Additional EBS block devices to attach to the instance"
  type        = "list"
  default     = []
}

variable "ephemeral_block_device" {
  description = "Customize Ephemeral (also known as Instance Store) volumes on the instance"
  type        = "list"
  default     = []
}

variable "user_data" {
  description = "The user data to provide when launching the instance"
  type        = "string"
  default     = ""
}

#variable "availability_zone" {
#  description = "The AZ to start the instance in"
#  type        = "string"
#  default     = ""
#}

variable "associate_public_ip_address" {
  description = "If true, the EC2 instance will have associated public IP address"
  type        = "string"
  default     = false
}

variable "private_ip" {
  description = "Private IP address to associate with the instance in a VPC"
  type        = "string"
  default     = ""
}

variable "ipv6_address_count" {
  description = "A number of IPv6 addresses to associate with the primary network interface. Amazon EC2 chooses the IPv6 addresses from the range of your subnet."
  type        = "string"
  default     = 0
}

variable "ipv6_addresses" {
  description = "Specify one or more IPv6 addresses from the range of the subnet to associate with the primary network interface"
  type        = "list"
  default     = []
}

variable "name" {
  description = "The name of the VPC"
  type        = "string"
}

variable "default_tags" {
  description = "Default tags which will be applied to everything"
  type        = "map"
  default     = {
                  "Terraform" = "true"
                }
}

variable "tags" {
  description = "A mapping of tags to assign to security group"
  type        = "map"
  default     = {}
}

variable "vpc_id" {
  description = "ID of the VPC where to create security group"
  type        = "string"
}

variable "description" {
  description = "Description of security group"
  type        = "string"
  default     = "Security Group managed by Terraform"
}

##########
# Ingress
##########
variable "ingress_rules" {
  description = "List of ingress rules to create"
  type        = "list"
  default     = []
}

variable "ingress_cidr_blocks" {
  description = "List of IPv4 CIDR ranges to use on ingress rules without source security group"
  type        = "list"
  default     = []
}

variable "ipv6_ingress_cidr_blocks" {
  description = "List of IPv6 CIDR ranges to use on ingress rules"
  type        = "list"
  default     = []
}

variable "ingress_prefix_list_ids" {
  description = "List of prefix list IDs (for allowing access to VPC endpoints) to use on all ingress rules"
  type        = "list"
  default     = []
}

# ingress rules with source security group
variable "ingress_rules_source_sg" {
  description = "List of ingress rules to create where 'source_security_group_id' is used"
  type        = "list"
  default     = []
}

variable "ingress_rules_source_sg_security_group_id" {
  description = "IDs of the security group for the ingress rules with source security group"
  type        = "string"
  default     = ""
}

#########
# Egress
#########
variable "egress_rules" {
  description = "List of egress rules to create by name"
  type        = "list"
  default     = []
}

variable "egress_cidr_blocks" {
  description = "List of IPv4 CIDR ranges to use on all egress rules"
  type        = "list"
  default     = ["0.0.0.0/0"]
}

variable "ipv6_egress_cidr_blocks" {
  description = "List of IPv6 CIDR ranges to use on egress rules"
  type        = "list"
  default     = []
}

variable "egress_prefix_list_ids" {
  description = "List of prefix list IDs (for allowing access to VPC endpoints) to use on all egress rules"
  type        = "list"
  default     = []
}

variable "prefix_list_ids" {
  description = "List of prefix list IDs (for allowing access to VPC endpoints). Only valid with egress."
  type        = "list"
  default     = []
}

# egress rules with source security group
variable "egress_rules_source_sg" {
  description = "List of egress rules to create where 'source_security_group_id' is used"
  type        = "list"
  default     = []
}

variable "egress_rules_source_sg_security_group_id" {
  description = "IDs of the security group for the egress rules with source security group"
  type        = "string"
  default     = ""
}

variable "load_balancer_name" {
  description = "The resource name and Name tag of the load balancer."
}

#variable "security_groups_alb" {
#  description = "The security groups to attach to the load balancer. e.g. [\"sg-edcd9784\",\"sg-edcd9785\"]"
#  type        = "list"
#}

variable "subnets_alb" {
  description = "A list of subnets to associate with the load balancer. e.g. ['subnet-1a2b3c4d','subnet-1a2b3c4e','subnet-1a2b3c4f']"
  type        = "list"
}

variable "tags" {
  description = "A map of tags to add to all resources"
  default     = {}
}

variable "vpc_id" {
  description = "The VPC ID of the VPC where the load balancer is created"
  type        = "string"
}

variable "egress_target_security_group" {
  description = "The security group of the targets for the load balancer, i.e. the instances hosting the application"
  type        = "string"
}

variable "cidr_blocks_vpc" {
  description = "CIDR block of the VPC to allow ingress from all IPs in VPC"
  type        = "list"
}

variable "cidr_blocks_gatling" {
  description = "CIDR block of the gatling/client servers"
  type        = "list"
}

variable "certificate_arn" {
    type = "string"
    description = "The ARN of the SSL server certificate"
}

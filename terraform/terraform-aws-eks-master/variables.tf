variable "region" {
  description = "AWS region"
}

variable "vpc_id" {
  description = "ID of VPC to deploy the cluster"
}

variable "private_subnets" {
  type        = "list"
  description = "All private subnets in your VPC"
}

variable "cluster_prefix" {
  description = "Name prefix of your EKS cluster"
}

variable "http_proxy" {
  description = "IP[:PORT] address and  port of HTTP proxy for your environment"
  default     = ""
}

variable "no_proxy" {
  description = "Endpoint that do not need to go through proxy"
  default     = ""
}

variable "key_name" {
  description = "Key pair to use to access the instance created by the ASG/LC"
}

variable "outputs_directory" {
  description = "The local folder path to store output files. Must end with '/' ."
  default     = "./output/"
}

variable "max_worker_nodes" {
  description = "Maximum amount of worker nodes to spin up"
  default     = "6"
}

variable "desired_worker_nodes" {
  description = "Desired amount of worker nodes (needs to be => then minimum worker nodes)"
  default     = "1"
}

variable "min_worker_nodes" {
  description = "Minimum amount of worker nodes (needs to be <= then desired worker nodes)."
  default     = "1"
}

variable "worker_node_instance_type" {
  default = "m4.large"
}

variable "aws_authenticator_env_variables" {
  description = "A map of environment variables to use in the eks kubeconfig for aws authenticator"
  type        = "map"
  default     = {}
}

variable "tags" {
  description = "Map of tags to apply to deployed resources"
  type        = "map"
  default     = {}
}

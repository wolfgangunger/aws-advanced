locals {
  worker_group = [
    {
      name                 = "node"                                                  # Name of the worker group. Literal count.index will never be used but if name is not set, the count.index interpolation will be used.
      asg_desired_capacity = "${var.desired_worker_nodes}"                           # Desired worker capacity in the autoscaling group.
      asg_max_size         = "${var.max_worker_nodes}"                               # Maximum worker capacity in the autoscaling group.
      asg_min_size         = "${var.min_worker_nodes}"                               # Minimum worker capacity in the autoscaling group.
      instance_type        = "${var.worker_node_instance_type}"                      # Size of the workers instances.
      key_name             = "${var.key_name}"                                       # The key name that should be used for the instances in the autoscaling group
      pre_userdata         = "${data.template_file.http_proxy_workergroup.rendered}" # userdata to pre-append to the default userdata.
      additional_userdata  = ""                                                      # userdata to append to the default userdata.
      subnets              = "${join(",", var.private_subnets)}"                     # A comma delimited string of subnets to place the worker nodes in. i.e. subnet-123,subnet-456,subnet-789
    },
  ]

  master_config_services_proxy = [
    {
      name = "kube-proxy"
      type = "daemonset"
    },
    {
      name = "coredns"
      type = "deployment"
    },
    {
      name = "aws-node"
      type = "daemonset"
    },
  ]
}

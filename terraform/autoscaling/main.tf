/* Modules from Terraform registry that this module is based on:
   * https://registry.terraform.io/modules/terraform-aws-modules/autoscaling/aws/2.0.0
   * https://registry.terraform.io/modules/anugnes/ecs-scalable-cluster/aws/1.1.4
 */

#################
# Auto-scaling group and launch configuration
#################

#################
# Launch configuration
#################
resource "aws_launch_configuration" "this" {
  name          = "${var.name}"
  image_id      = "${var.image_id}"
  instance_type = "${var.instance_type}"

  iam_instance_profile        = "${var.iam_instance_profile}"
  key_name                    = "${var.key_name}"
  security_groups             = ["${var.security_groups}"]
  associate_public_ip_address = "${var.associate_public_ip_address}"
  user_data                   = "${var.user_data}"
  enable_monitoring           = "${var.enable_monitoring}"
  placement_tenancy           = "${var.placement_tenancy}"
  ebs_optimized               = "${var.ebs_optimized}"
  ebs_block_device            = "${var.ebs_block_device}"
  ephemeral_block_device      = "${var.ephemeral_block_device}"
  root_block_device           = "${var.root_block_device}"
#  spot_price                  = "${var.spot_price}"

  lifecycle {
    create_before_destroy = true
  }
}

######
# Autoscaling Group
######
resource "aws_autoscaling_group" "this" {
  name                 = "${var.name}"
  launch_configuration = "${aws_launch_configuration.this.id}"

  max_size = "${var.max_size}"
  min_size = "${var.min_size}"
  desired_capacity = "${var.desired_capacity}"      # you can also use autoscaling policy instead

  vpc_zone_identifier  = ["${var.vpc_zone_identifier}"]

  load_balancers            = ["${var.load_balancers}"]
  health_check_grace_period = "${var.health_check_grace_period}"
  health_check_type         = "${var.health_check_type}"

  min_elb_capacity          = "${var.min_elb_capacity}"
  wait_for_elb_capacity     = "${var.wait_for_elb_capacity}"
  target_group_arns         = ["${var.target_group_arns}"]
  default_cooldown          = "${var.default_cooldown}"
  force_delete              = "${var.force_delete}"
  termination_policies      = ["OldestInstance"]
  suspended_processes       = "${var.suspended_processes}"
  placement_group           = "${var.placement_group}"
  enabled_metrics = [
    "GroupMaxSize",
    "GroupMinSize",
    "GroupInServiceInstances",
    "GroupTerminatingInstances",
    "GroupTotalInstances",
    "GroupPendingInstances",
    "GroupStandbyInstances",
  ]

  wait_for_capacity_timeout = "${var.wait_for_capacity_timeout}"
  protect_from_scale_in     = "${var.protect_from_scale_in}"

  tags = ["${concat(
      var.tags,
      list(map("key", "Name", "value", var.name, "propagate_at_launch", true))
   )}"]

}

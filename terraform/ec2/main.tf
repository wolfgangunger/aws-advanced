/* Modules from Terraform registry that this module is based on:
   * https://registry.terraform.io/modules/terraform-aws-modules/ec2-instance/aws/1.0.4
   * https://registry.terraform.io/modules/trung/ec2-instance-simple/aws/0.0.1
 */


######
# EC2 instances
# This creates {count} number of instances of the same type.
# The instances are created in the same region and the same VPC.
# The instances are distributed among the subnets given as input (round robin).
######
resource "aws_instance" "this" {
  count = "${var.count}"

  ami                    = "${var.ami}"
  instance_type          = "${var.instance_type}"

  subnet_id              = "${element(var.subnet_ids, count.index % length(var.subnet_ids))}"
  key_name               = "${var.key_name}"

  #network_interface {
  # ! not working. For now going with just the ENI that is created automatically when the instance is launched.
  #   network_interface_id = "${element(aws_network_interface.network_interface.*.id, count.index)}"
  #   device_index         = "${var.device_index}"
  #}

  monitoring             = "${var.monitoring}"
  vpc_security_group_ids = ["${var.security_group_ids}"]
  iam_instance_profile   = "${var.iam_instance_profile}"

  ebs_optimized          = "${var.ebs_optimized}"
  volume_tags            = "${var.volume_tags}"
  root_block_device      = "${var.root_block_device}"
  ebs_block_device       = "${var.ebs_block_device}"
  ephemeral_block_device = "${var.ephemeral_block_device}"

  source_dest_check                    = "${var.source_dest_check}"
  disable_api_termination              = "${var.disable_api_termination}"
  instance_initiated_shutdown_behavior = "${var.instance_initiated_shutdown_behavior}"
  placement_group                      = "${var.placement_group}"
  tenancy                              = "${var.tenancy}"

  user_data                   = "${var.user_data}"
  # availability_zone           = "${var.availability_zone}"     # use subnet instead
  associate_public_ip_address = "${var.associate_public_ip_address}"     # not needed for instances in private subnets
  private_ip                  = "${var.private_ip}"
  ipv6_address_count          = "${var.ipv6_address_count}"
  ipv6_addresses              = "${var.ipv6_addresses}"

  tags = "${merge(var.default_tags, var.tags, map("Name", format("%s-%d", var.name, count.index+1)))}"
}

#################
# EC2 instances
#################

#################
# Network interfaces
# This creates {count} number of ENIs.
# They are created in the same region and the same VPC.
# They are distributed among the subnets given as input.
#################
#resource "aws_network_interface" "network_interface" {
# !! does not work, see https://github.com/hashicorp/terraform/issues/6750
#  count             = "${var.count}"

#  subnet_id         = "${element(var.subnet_ids, count.index % length(var.subnet_ids))}" # distribute the same way as instances
#  private_ips       = ["${element(var.private_ips_eni, count.index)}"]                   # one IP per network interface
#  security_groups   = ["${var.security_group_ids}"]                                      # same security groups as the instances
#  source_dest_check = "${var.source_dest_check}"

#  tags = "${merge(var.default_tags, var.tags, map("Name", format("%s-%d", var.name, count.index+1)))}"
#}

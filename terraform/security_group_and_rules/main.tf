/* Modules from Terraform registry that this module is based on:
   * https://registry.terraform.io/modules/terraform-aws-modules/security-group/aws/1.9.0
   * https://registry.terraform.io/modules/Smartbrood/security-group/aws/0.5.0
 */

################
# Security Group
################
resource "aws_security_group" "this" {
  name        = "${var.name}"
  description = "${var.description}"
  vpc_id      = "${var.vpc_id}"

  tags = "${merge(var.default_tags, var.tags, map("Name", format("%s", var.name)), map("Created", format("%s", timestamp())))}"
}

###########
# Ingress Rules
###########
resource "aws_security_group_rule" "ingress_rules" {
  count = "${length(var.ingress_rules)}"

  security_group_id = "${aws_security_group.this.id}"
  type              = "ingress"

  cidr_blocks       = ["${var.ingress_cidr_blocks}"]
  ipv6_cidr_blocks  = ["${var.ipv6_ingress_cidr_blocks}"]

  from_port = "${element(var.ingress_rules[count.index], 0)}"
  to_port   = "${element(var.ingress_rules[count.index], 1)}"
  protocol  = "${element(var.ingress_rules[count.index], 2)}"
}

# ingress rule with source security group -> used e.g. for ELB
resource "aws_security_group_rule" "ingress_rules_source_sg" {
  count = "${length(var.ingress_rules_source_sg)}"

  security_group_id = "${aws_security_group.this.id}"
  type              = "ingress"

  source_security_group_id = "${var.ingress_rules_source_sg_security_group_id}"
  ipv6_cidr_blocks         = ["${var.ipv6_ingress_cidr_blocks}"]

  from_port = "${element(var.ingress_rules_source_sg[count.index], 0)}"
  to_port   = "${element(var.ingress_rules_source_sg[count.index], 1)}"
  protocol  = "${element(var.ingress_rules_source_sg[count.index], 2)}"
}

###########
# Egress Rules
###########
resource "aws_security_group_rule" "egress_rules" {
  count = "${length(var.egress_rules)}"

  security_group_id = "${aws_security_group.this.id}"
  type              = "egress"

  cidr_blocks       = ["${var.egress_cidr_blocks}"]
  ipv6_cidr_blocks  = ["${var.ipv6_egress_cidr_blocks}"]

  prefix_list_ids   = ["${var.prefix_list_ids}"]

  from_port = "${element(var.egress_rules[count.index], 0)}"
  to_port   = "${element(var.egress_rules[count.index], 1)}"
  protocol  = "${element(var.egress_rules[count.index], 2)}"
}

resource "aws_security_group_rule" "egress_rules_source_sg" {
  count = "${length(var.egress_rules_source_sg)}"

  security_group_id = "${aws_security_group.this.id}"
  type              = "egress"

  source_security_group_id = "${var.egress_rules_source_sg_security_group_id}"
  ipv6_cidr_blocks         = ["${var.ipv6_egress_cidr_blocks}"]

  from_port = "${element(var.egress_rules_source_sg[count.index], 0)}"
  to_port   = "${element(var.egress_rules_source_sg[count.index], 1)}"
  protocol  = "${element(var.egress_rules_source_sg[count.index], 2)}"
}

/* Modules from Terraform registry that this module is based on:
   * https://registry.terraform.io/modules/QuiNovas/rds-postgres/aws/2.0.0
   * https://registry.terraform.io/modules/terraform-aws-modules/rds/aws/1.22.0
 */

 ######
 # RDS instance
 # This creates one RDS instance with PostgreSQL engine from a snapshot.
 ######
resource "aws_db_instance" "rds_postgres" {
  instance_class      = "${var.instance_class}"
  snapshot_identifier = "${var.snapshot_identifier}"

  vpc_security_group_ids      = [
    "${aws_security_group.rds.id}"
  ]
  db_subnet_group_name        = "${aws_db_subnet_group.rds.name}"
  parameter_group_name        = "${aws_db_parameter_group.rds.name}"

  skip_final_snapshot         = "${var.skip_final_snapshot}"
  copy_tags_to_snapshot       = "${var.copy_tags_to_snapshot}"
  final_snapshot_identifier   = "${var.final_snapshot_identifier}"

  tags = "${merge(var.tags, map("Name", "${var.name}-db"))}"
}

resource "aws_db_subnet_group" "rds" {
  name        = "${var.name}-subnet-group"
  description = "Terraformed subnet group for RDS."
  subnet_ids  = ["${var.subnet_ids}"]

  tags = "${merge(var.tags, map("Name", "${var.name}-subnet-group"))}"
}

resource "aws_db_parameter_group" "rds" {
  family  = "postgres10"
  name    = "${var.name}-postgres10"
  parameter = [
    "${var.parameters}"
  ]

  tags = "${merge(var.tags, map("Name", format("%s", var.name)))}"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group" "rds" {
  name    = "${var.name}-sg"
  tags    = "${merge(var.tags, map("Name", "${var.name}-sg"))}"
  vpc_id  = "${var.vpc_id}"
}

resource "aws_security_group_rule" "ingress_from_all_vpc_ips" {
  from_port         = 5432
  to_port           = 5432
  protocol          = "tcp"
  security_group_id = "${aws_security_group.rds.id}"
  type              = "ingress"
  cidr_blocks       = "${var.cidr_blocks}"
}

resource "aws_security_group_rule" "all_egress" {
  cidr_blocks       = [
    "0.0.0.0/0"
  ]
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  security_group_id = "${aws_security_group.rds.id}"
  type              = "egress"
}

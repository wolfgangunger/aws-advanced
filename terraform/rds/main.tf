/* Modules from Terraform registry that this module is based on:
   * https://registry.terraform.io/modules/QuiNovas/rds-postgres/aws/2.0.0
   * https://registry.terraform.io/modules/terraform-aws-modules/rds/aws/1.22.0
 */


 ######
 # RDS instance
 # This creates one RDS instance with PostgreSQL engine.
 ######
resource "aws_db_instance" "rds_postgres" {
  engine            = "postgres"
  engine_version    = "${var.engine_version}"

  instance_class    = "${var.instance_class}"

  allocated_storage = "${var.allocated_storage}"
  storage_type      = "io1"
  iops              = "${var.iops}"
  storage_encrypted = "${var.storage_encrypted}" # if using encryption, add KMS

  name              = "${var.name}"
  username          = "${var.username}"
  password          = "${random_string.master_password.result}"

  storage_encrypted = "true"
  kms_key_id        = "${aws_kms_key.rds.arn}"

  port              = "${var.port}"

  vpc_security_group_ids      = [
    "${aws_security_group.rds.id}"
  ]
  db_subnet_group_name        = "${aws_db_subnet_group.rds.name}"
  parameter_group_name        = "${aws_db_parameter_group.rds.name}"

  availability_zone   = "${var.availability_zone}"
  multi_az            = "${var.multi_az}"

  monitoring_interval   = "${var.monitoring_interval}"
  #monitoring_role_arn   = "${aws_iam_role.monitoring.arn}"

  allow_major_version_upgrade = "${var.allow_major_version_upgrade}"
  auto_minor_version_upgrade  = "${var.auto_minor_version_upgrade}"
  apply_immediately           = "${var.apply_immediately}"
  maintenance_window          = "${var.maintenance_window}"
  skip_final_snapshot         = "${var.skip_final_snapshot}"
  copy_tags_to_snapshot       = "${var.copy_tags_to_snapshot}"
  final_snapshot_identifier   = "${var.final_snapshot_identifier}"

  backup_retention_period = "${var.backup_retention_period}"
  backup_window           = "${var.backup_window}"

  enabled_cloudwatch_logs_exports = "${var.enabled_cloudwatch_logs_exports}"

  deletion_protection = "${var.deletion_protection}"

  tags = "${merge(var.tags, map("Name", format("%s", var.name)))}"
}

# password for database -> randomly generated
# can be retrieved via output
resource "random_string" "master_password" {
  length            = 64
  lower             = true
  number            = true
  special           = true
  override_special  = "!#$%*()-_=+[]{}:?"
  upper             = true
}

# The IAM IDs have to be adapted
resource "aws_kms_key" "rds" {
  description = "Encryption key for the RDS Postgres database created by Terraform"
  tags = "${var.tags}"
  policy = "${file("${var.policy_file_name}.json")}"
#  policy = <<EOF
#{
#    "Version": "2012-10-17",
#    "Id": "key-consolepolicy-3",
#    "Statement": [
#        {
#            "Sid": "Enable IAM User Permissions",
#            "Effect": "Allow",
#            "Principal": {
#                "AWS": "arn:aws:iam::906781655012:root"
#            },
#            "Action": "kms:*",
#            "Resource": "*"
#        },
#        {
#            "Sid": "Allow access for Key Administrators",
#            "Effect": "Allow",
#            "Principal": {
#                "AWS": "arn:aws:iam::906781655012:role/ccc-administration/OwnFull"
#            },
#            "Action": [
#                "kms:Create*",
#                "kms:Describe*",
#                "kms:Enable*",
#                "kms:List*",
#                "kms:Put*",
#                "kms:Update*",
#                "kms:Revoke*",
#                "kms:Disable*",
#                "kms:Get*",
#                "kms:Delete*",
#                "kms:TagResource",
#                "kms:UntagResource",
#                "kms:ScheduleKeyDeletion",
#                "kms:CancelKeyDeletion"
#            ],
#            "Resource": "*"
#        },
#        {
#            "Sid": "Allow use of the key",
#            "Effect": "Allow",
#            "Principal": {
#                "AWS": "arn:aws:iam::906781655012:role/ccc-administration/OwnFull"
#            },
#            "Action": [
#                "kms:Encrypt",
#                "kms:Decrypt",
#                "kms:ReEncrypt*",
#                "kms:GenerateDataKey*",
#                "kms:DescribeKey"
#            ],
#            "Resource": "*"
#        },
#        {
#            "Sid": "Allow attachment of persistent resources",
#            "Effect": "Allow",
#            "Principal": {
#                "AWS": "arn:aws:iam::906781655012:role/ccc-administration/OwnFull"
#            },
#            "Action": [
#                "kms:CreateGrant",
#                "kms:ListGrants",
#                "kms:RevokeGrant"
#            ],
#            "Resource": "*",
#            "Condition": {
#                "Bool": {
#                    "kms:GrantIsForAWSResource": "true"
#                }
#            }
#        }
#    ]
#}
#EOF
}

resource "aws_kms_alias" "rds" {
  name          = "alias/${var.name}"
  target_key_id = "${aws_kms_key.rds.id}"
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

# use only if both SVDS instances and RDS are created at the same time
#resource "aws_security_group_rule" "ingress_from_svds" {
#  from_port         = 5432
#  to_port           = 5432
#  protocol          = "tcp"
#  security_group_id = "${aws_security_group.rds.id}"
#  type              = "ingress"
#
#  # specifiy the security group id of the SVDS servers
#  source_security_group_id = "${var.source_security_group_svds_id}"
#}


#resource "aws_security_group_rule" "ingress_from_other_ec2" {
#  from_port         = 5432
#  to_port           = 5432
#  protocol          = "tcp"
#  security_group_id = "${aws_security_group.rds.id}"
#  type              = "ingress"
#
#  # specifiy the security group id of the EC2 servers created by hand
#  # the security group ID has to be added manually in the main terraform script
#  source_security_group_id = "${var.source_security_group_ec2_id}"
#}

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

/* Modules from Terraform registry that this module is based on:
   * https://registry.terraform.io/modules/terraform-aws-modules/alb/aws/3.5.0
   * https://registry.terraform.io/modules/kurron/alb/aws/0.9.3
 */

#################
# Application load balancer
#################

#################
# Application load balancer without access logs
#################
resource "aws_lb" "alb" {
    name                       = "${var.load_balancer_name}"
    internal                   = "true"
    load_balancer_type         = "application"

    security_groups            = ["${aws_security_group.sg.id}"]
    subnets                    = ["${var.subnets_alb}"]

    idle_timeout               = 60 # seconds that connection is allowed to be idle
    enable_deletion_protection = false
    ip_address_type            = "ipv4"

    tags   = "${merge(var.tags, map("Name", var.load_balancer_name))}"

    timeouts {
        create = "10m"
        update = "10m"
        delete = "10m"
    }
}

#################
# Security group and rules for load balancer
#################
resource "aws_security_group" "sg" {
  name        = "${var.load_balancer_name}-sg"
  description = "Security group for application load balancer, created via Terraform"
  vpc_id      = "${var.vpc_id}"

  tags = "${merge(var.tags, map("Name", "${var.load_balancer_name}-sg"))}"
}

resource "aws_security_group_rule" "egress" {
  security_group_id = "${aws_security_group.sg.id}"
  type              = "egress"
  protocol          = "-1"
  from_port         = 0
  to_port           = 0

  source_security_group_id = "${var.egress_target_security_group}"
}

resource "aws_security_group_rule" "ingress_from_all_vpc_ips" {
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  security_group_id = "${aws_security_group.sg.id}"
  type              = "ingress"
  cidr_blocks       = "${var.cidr_blocks_vpc}"
}

resource "aws_security_group_rule" "ingress_from_gatling" {
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  security_group_id = "${aws_security_group.sg.id}"
  type              = "ingress"
  cidr_blocks       = "${var.cidr_blocks_gatling}"
}

#################
# Target group HTTP 8080
#################
resource "aws_lb_target_group" "http_target" {
    name             = "${var.load_balancer_name}-http-target"

    port                 = "8080"
    protocol             = "HTTP"

    vpc_id               = "${var.vpc_id}"
    target_type          = "instance"

    deregistration_delay = 300

    stickiness {
        type            = "lb_cookie"
        cookie_duration = 86400
        enabled         = "true"
    }

    tags   = "${merge(var.tags, map("Name", var.load_balancer_name))}"
}

#################
# Listener HTTP 8080
#################
resource "aws_lb_listener" "http_listener" {
  load_balancer_arn = "${aws_lb.alb.arn}"
  port              = "8080"
  protocol          = "HTTP"

  default_action {
    target_group_arn = "${aws_lb_target_group.http_target.arn}"
    type             = "forward"
  }
}

#################
# Target group HTTPS 8181
#################
resource "aws_lb_target_group" "https_target" {
    name             = "${var.load_balancer_name}-https-target"

    port                 = "8181"
    protocol             = "HTTPS"

    vpc_id               = "${var.vpc_id}"
    target_type          = "instance"

    deregistration_delay = 300

    stickiness {
        type            = "lb_cookie"
        cookie_duration = 86400
        enabled         = "true"
    }

    tags   = "${merge(var.tags, map("Name", var.load_balancer_name))}"
}

#################
# Listener HTTPS 8181
#################
resource "aws_lb_listener" "https_listener" {
  load_balancer_arn = "${aws_lb.alb.arn}"
  port              = "8181"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08" # default policy
  certificate_arn   = "${var.certificate_arn}"

  default_action {
    target_group_arn = "${aws_lb_target_group.https_target.arn}"
    type             = "forward"
  }
}

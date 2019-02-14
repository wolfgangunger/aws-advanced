output "alb_id" {
    value = "${aws_lb.alb.id}"
    description = "ID of the created ALB"
}

output "alb_arn" {
    value = "${aws_lb.alb.arn}"
    description = "ARN of the created ALB"
}

output "alb_dns_name" {
    value = "${aws_lb.alb.dns_name}"
    description = "The DNS name of the load balancer."
}

output "alb_zone_id" {
    value = "${aws_lb.alb.zone_id}"
    description = "The canonical hosted zone ID of the load balancer (to be used in a Route 53 Alias record)."
}

output "alb_arn_suffix" {
    value = "${aws_lb.alb.arn_suffix}"
    description = "The ARN suffix for use with CloudWatch Metrics."
}

output "http_target_group_id" {
    value = "${aws_lb_target_group.http_target.id}"
    description = "The id of the HTTP Target Group"
}

output "http_target_group_arn" {
    value = "${aws_lb_target_group.http_target.arn}"
    description = "The ARN of the HTTP Target Group"
}

output "https_target_group_id" {
    value = "${aws_lb_target_group.https_target.id}"
    description = "The id of the HTTPS Target Group"
}

output "https_target_group_arn" {
    value = "${aws_lb_target_group.https_target.arn}"
    description = "The ARN of the HTTPS Target Group"
}

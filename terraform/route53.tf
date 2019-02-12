resource "aws_route53_record" "sourcegraph" {
  zone_id = "${var.hosted_zone_id}"
  name    = "sourcegraph.hodly.group"
  type    = "A"
  ttl     = "300"
  records = ["${aws_instance.web.public_ip}"]
}

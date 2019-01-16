## Adding 'A' Record to the domain to create sub domain

resource "aws_route53_record" "domainrecord" {
  zone_id = "${data.aws_route53_zone.primary.zone_id}"
  name    = "${var.domainName}"
  type    = "A"

  alias {
    name                   = "${aws_alb.alb.dns_name}"
    zone_id                = "${aws_alb.alb.zone_id}"
    evaluate_target_health = true
  }
}

data  "aws_route53_zone" "primary" {
  name         = "${var.primarydomainName}"
  # private_zone = true
} 
variable "domain" {
  type = "string"
}

resource "aws_route53_zone" "main" {
  name = "${var.domain}"
}

output "name_servers" {
  value = "${aws_route53_zone.main.name_servers}"
}

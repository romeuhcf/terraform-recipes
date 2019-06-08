
resource "tls_private_key" "acme_registration_private_key" {
  algorithm = "RSA"
}

resource "acme_registration" "reg" {
  email_address   = "${var.acme_registration_email}"
  account_key_pem = "${tls_private_key.acme_registration_private_key.private_key_pem}"
}

resource "acme_certificate" "certificate" {
  account_key_pem = "${acme_registration.reg.account_key_pem}"
  common_name     = "${var.common_name_domain_prefix}${var.domain}"
  dns_challenge {
    provider = "route53"
  }
}

resource "aws_iam_server_certificate" "elb_cert" {
  name_prefix = "${var.app_name}-cert-"

  certificate_body  = "${acme_certificate.certificate.certificate_pem}"
  certificate_chain = "${acme_certificate.certificate.issuer_pem}"
  private_key       = "${acme_certificate.certificate.private_key_pem}"
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_elb" "main-elb" {
  name            = "${var.app_name}-main-elb"
  subnets         = ["${aws_subnet.main-public-1.id}", "${aws_subnet.main-public-2.id}"]
  security_groups = ["${aws_security_group.elb-securitygroup.id}"]
  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }

  listener {
    instance_port      = 80
    instance_protocol  = "http"
    lb_port            = 443
    lb_protocol        = "https"
    ssl_certificate_id = "${aws_iam_server_certificate.elb_cert.arn}"

  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "HTTP:80/"
    interval            = 30
  }

  cross_zone_load_balancing   = true
  connection_draining         = true
  connection_draining_timeout = 400
}


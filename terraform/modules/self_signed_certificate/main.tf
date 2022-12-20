resource "tls_private_key" "rsa_private_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_ssm_parameter" "rsa_private_key" {
  name      = "/${var.tags["Name"]}/rsa_private_key"
  type      = "SecureString"
  value     = tls_private_key.rsa_private_key.private_key_pem
  overwrite = true

  tags = var.tags

  lifecycle {
    ignore_changes = [
      value
    ]
  }
}

resource "tls_cert_request" "ssl_signing_certificate" {
  key_algorithm   = tls_private_key.rsa_private_key.algorithm
  private_key_pem = tls_private_key.rsa_private_key.private_key_pem

  subject {
    common_name = "cjse.org"
  }

  dns_names = [
    "*.cjse.org"
  ]
}

resource "aws_ssm_parameter" "ssl_signing_certificate" {
  name      = "/${var.tags["Name"]}/ssl_signing_certificate"
  type      = "SecureString"
  value     = tls_cert_request.ssl_signing_certificate.cert_request_pem
  overwrite = true

  tags = var.tags

  lifecycle {
    ignore_changes = [
      value
    ]
  }
}

resource "tls_self_signed_cert" "self_signed_certificate" {
  allowed_uses = [
    "key_encipherment",
    "digital_signature",
    "server_auth"
  ]

  key_algorithm   = tls_private_key.rsa_private_key.algorithm
  private_key_pem = tls_private_key.rsa_private_key.private_key_pem

  validity_period_hours = 8760

  subject {
    common_name = "cjse.org"
  }

  dns_names = [
    "*.cjse.org"
  ]
}

resource "aws_ssm_parameter" "self_signed_certificate" {
  name      = "/${var.tags["Name"]}/self_signed_certificate"
  type      = "SecureString"
  value     = tls_self_signed_cert.self_signed_certificate.cert_pem
  overwrite = true

  tags = var.tags

  lifecycle {
    ignore_changes = [
      value
    ]
  }
}

resource "aws_iam_server_certificate" "self_signed_certificate" {
  name_prefix = "${var.tags["Name"]}.cjse.org"

  certificate_body = tls_self_signed_cert.self_signed_certificate.cert_pem
  private_key      = tls_private_key.rsa_private_key.private_key_pem
}

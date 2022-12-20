output "server_certificate" {
  description = "The ssl certificate we have created for this deployment"
  value = {
    arn                  = aws_iam_server_certificate.self_signed_certificate.arn
    id                   = aws_iam_server_certificate.self_signed_certificate.id
    name                 = aws_iam_server_certificate.self_signed_certificate.name
    certificate          = aws_iam_server_certificate.self_signed_certificate.certificate_body
    ssm_certificate_path = aws_ssm_parameter.self_signed_certificate.name
    ssm_certificate_arn  = aws_ssm_parameter.self_signed_certificate.arn
    ssm_key_path         = aws_ssm_parameter.rsa_private_key.name
    ssm_key_arn          = aws_ssm_parameter.rsa_private_key.arn
  }
  sensitive = true
}

# CloudFront에서 사용할 인증서 ARN 출력
output "certificate_arn" {
  value = aws_acm_certificate.cert.arn
}

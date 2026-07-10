output "bucket_name" {
  value = aws_s3_bucket.static_site.id
}

output "bucket_domain_name" {
  value = aws_s3_bucket.static_site.bucket_domain_name
}

output "website_endpoint" {
  value = aws_s3_bucket_website_configuration.website.website_endpoint
}

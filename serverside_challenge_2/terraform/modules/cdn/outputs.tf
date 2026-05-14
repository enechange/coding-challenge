output "cloudfront_domain_name" {
  value       = aws_cloudfront_distribution.main.domain_name
  description = "CloudFront ドメイン名 (xxx.cloudfront.net)。NEXT_PUBLIC_API_URL に設定する"
}

output "cloudfront_distribution_id" {
  value = aws_cloudfront_distribution.main.id
}

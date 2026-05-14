output "tfstate_bucket_name" {
  value       = aws_s3_bucket.tfstate.bucket
  description = "tfstate を格納する S3 バケット名。terraform/main.tf の backend.bucket に設定する"
}

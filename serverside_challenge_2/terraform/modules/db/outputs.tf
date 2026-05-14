output "db_endpoint" {
  value       = aws_db_instance.main.endpoint
  description = "RDS エンドポイント (host:port)。DATABASE_URL 組み立て時に使用"
}

output "db_name" {
  value = aws_db_instance.main.db_name
}

output "master_user_secret_arn" {
  value       = tolist(aws_db_instance.main.master_user_secret)[0].secret_arn
  description = "RDS が自動生成したマスターパスワードの Secrets Manager ARN"
}

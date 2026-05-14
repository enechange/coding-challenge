output "cloudfront_domain_name" {
  value       = module.cdn.cloudfront_domain_name
  description = "CloudFront ドメイン名。フロントエンドの NEXT_PUBLIC_API_URL に https://<この値> を設定する"
}

output "ecr_repository_url" {
  value       = module.app.ecr_repository_url
  description = "ECR リポジトリ URL。docker build/push 時のイメージタグに使用する"
}

output "alb_dns_name" {
  value       = module.app.alb_dns_name
  description = "ALB DNS 名（CloudFront 経由でアクセスすること）"
}

output "ecs_cluster_name" {
  value       = module.app.ecs_cluster_name
  description = "ECS クラスター名（db:migrate ワンオフタスク実行時に使用）"
}

output "ecs_task_definition_arn" {
  value       = module.app.ecs_task_definition_arn
  description = "ECS タスク定義 ARN（db:migrate ワンオフタスク実行時に使用）"
}

output "database_url_secret_arn" {
  value       = module.app.database_url_secret_arn
  description = "DATABASE_URL の Secrets Manager ARN（aws secretsmanager put-secret-value で値を投入）"
}

output "secret_key_base_secret_arn" {
  value       = module.app.secret_key_base_secret_arn
  description = "SECRET_KEY_BASE の Secrets Manager ARN（aws secretsmanager put-secret-value で値を投入）"
}

output "db_endpoint" {
  value       = module.db.db_endpoint
  description = "RDS エンドポイント (host:port)。DATABASE_URL 組み立て時に使用"
}

output "rds_master_user_secret_arn" {
  value       = module.db.master_user_secret_arn
  description = "RDS が自動生成したマスターパスワードの Secrets Manager ARN"
}

output "public_subnet_ids" {
  value       = module.network.public_subnet_ids
  description = "ECS run-task 実行時の subnet ID リスト"
}

output "ecs_sg_id" {
  value       = module.app.ecs_sg_id
  description = "ECS run-task 実行時のセキュリティグループ ID"
}

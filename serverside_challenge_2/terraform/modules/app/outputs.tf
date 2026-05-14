output "alb_dns_name" {
  value       = aws_lb.main.dns_name
  description = "ALB の DNS 名（CloudFront のオリジンに設定）"
}

output "ecr_repository_url" {
  value       = aws_ecr_repository.app.repository_url
  description = "ECR リポジトリ URL（docker push 先）"
}

output "ecs_cluster_name" {
  value       = aws_ecs_cluster.main.name
  description = "ECS クラスター名（ワンオフタスク実行時に使用）"
}

output "ecs_task_definition_arn" {
  value       = aws_ecs_task_definition.app.arn
  description = "ECS タスク定義 ARN（ワンオフタスク実行時に使用）"
}

output "ecs_sg_id" {
  value       = var.sg_ecs_id
  description = "ECS セキュリティグループ ID（ワンオフタスク実行時に使用）"
}

output "database_url_secret_arn" {
  value       = aws_secretsmanager_secret.database_url.arn
  description = "DATABASE_URL Secrets Manager ARN（値の手動投入時に使用）"
}

output "secret_key_base_secret_arn" {
  value       = aws_secretsmanager_secret.secret_key_base.arn
  description = "SECRET_KEY_BASE Secrets Manager ARN（値の手動投入時に使用）"
}

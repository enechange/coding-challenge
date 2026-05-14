variable "project" {
  type = string
}

variable "env" {
  type = string
}

variable "region" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "public_subnet_ids" {
  type = list(string)
}

variable "sg_alb_id" {
  type = string
}

variable "sg_ecs_id" {
  type = string
}

variable "rails_image" {
  type        = string
  description = "Rails API Docker image URI (ECR)"
}

variable "cors_allowed_origins" {
  type        = string
  description = "CORS_ALLOWED_ORIGINS 環境変数の値 (例: https://your-app.vercel.app)"
}

variable "origin_verify_secret" {
  type        = string
  sensitive   = true
  description = "CloudFront → ALB 間の X-Origin-Verify ヘッダー値"
}

variable "database_url" {
  type      = string
  sensitive = true
  default   = null
}

variable "secret_key_base" {
  type      = string
  sensitive = true
  default   = null
}

variable "ecs_desired_count" {
  type    = number
  default = 0
}

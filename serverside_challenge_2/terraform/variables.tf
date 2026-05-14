variable "project" {
  type        = string
  default     = "enechange-coding-challenge"
  description = "プロジェクト識別子。リソース名のプレフィックスに使用"
}

variable "env" {
  type        = string
  default     = "prod"
  description = "環境識別子 (prod / stg など)"
}

variable "region" {
  type        = string
  default     = "ap-northeast-1"
  description = "AWS リージョン"
}

variable "rails_image" {
  type        = string
  description = "Rails API Docker image URI (ECR)"
}

variable "cors_allowed_origins" {
  type        = string
  description = "CORS を許可するオリジン (例: https://your-app.vercel.app)"
}

variable "origin_verify_secret" {
  type        = string
  sensitive   = true
  description = "CloudFront → ALB 間の X-Origin-Verify ヘッダー値。推測困難な値を設定すること"

  validation {
    condition     = var.origin_verify_secret != "CHANGE_ME"
    error_message = "origin_verify_secret must be changed from the example value."
  }

  validation {
    condition     = length(var.origin_verify_secret) >= 32
    error_message = "origin_verify_secret must be at least 32 characters."
  }

  validation {
    condition = (
      can(regex("[A-Za-z]", var.origin_verify_secret)) &&
      can(regex("[0-9]", var.origin_verify_secret))
    )
    error_message = "origin_verify_secret must contain both letters and digits."
  }
}

variable "database_url" {
  type        = string
  sensitive   = true
  default     = null
  description = "Rails DB 接続 URL。初回 apply 時は null 可。設定後 re-apply で ECS に反映される"
}

variable "secret_key_base" {
  type        = string
  sensitive   = true
  default     = null
  description = "Rails の SECRET_KEY_BASE。openssl rand -hex 64 で生成"
}

variable "ecs_desired_count" {
  type        = number
  default     = 0
  description = "ECS サービスの desired_count。シークレット設定前は 0 のままにする"

  validation {
    condition     = var.ecs_desired_count >= 0
    error_message = "ecs_desired_count must be greater than or equal to 0."
  }

  validation {
    condition = (
      var.ecs_desired_count == 0 ||
      (var.database_url != null && var.secret_key_base != null)
    )
    error_message = "database_url and secret_key_base must be set when ecs_desired_count is greater than 0."
  }
}

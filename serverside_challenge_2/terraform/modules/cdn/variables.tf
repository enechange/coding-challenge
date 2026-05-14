variable "project" {
  type = string
}

variable "env" {
  type = string
}

variable "alb_dns_name" {
  type        = string
  description = "CloudFront のオリジンとなる ALB の DNS 名"
}

variable "origin_verify_secret" {
  type        = string
  sensitive   = true
  description = "ALB へ転送する X-Origin-Verify カスタムヘッダーの値"
}

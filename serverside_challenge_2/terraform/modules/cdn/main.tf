locals {
  name_prefix = "${var.project}-${var.env}"
}

resource "aws_cloudfront_distribution" "main" {
  enabled = true
  comment = "${local.name_prefix} API distribution"

  origin {
    domain_name = var.alb_dns_name
    origin_id   = "alb"

    custom_origin_config {
      http_port  = 80
      https_port = 443
      # 独自ドメイン + ACM を使わない低コスト構成のため、viewer 側 HTTPS は
      # CloudFront で終端し、origin の ALB へは HTTP で転送する。
      origin_protocol_policy = "http-only"
      origin_ssl_protocols   = ["TLSv1.2"]
    }

    # ALB 側でこのヘッダーを検証し CloudFront 以外からの直接アクセスを拒否する簡易策。
    custom_header {
      name  = "X-Origin-Verify"
      value = var.origin_verify_secret
    }
  }

  default_cache_behavior {
    target_origin_id       = "alb"
    viewer_protocol_policy = "redirect-to-https"

    # OPTIONS を含む全メソッドを許可（CORS preflight 対応）
    allowed_methods = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods  = ["GET", "HEAD"]

    # CachingDisabled managed policy: API 用途のためキャッシュ無効化
    cache_policy_id = "4135ea2d-6df8-44a3-9df3-4b5a84be39ad"

    # AllViewerExceptHostHeader: Host ヘッダー以外をオリジンへそのまま転送
    origin_request_policy_id = "b689b0a8-53d0-40ab-baf2-68738e2966ac"
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  # *.cloudfront.net の AWS 管理証明書を使用（独自ドメイン不要で HTTPS 化）
  viewer_certificate {
    cloudfront_default_certificate = true
  }

  tags = {
    Name = "${local.name_prefix}-cf"
  }
}

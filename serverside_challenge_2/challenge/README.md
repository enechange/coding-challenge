# README

サーバーサイドチャレンジ用 Rails 7 (API only) アプリケーション。

## 環境

- Ruby 3.1.2
- Rails 7.0.8
- PostgreSQL 18
- Docker / Docker Compose

## 初回セットアップ

```sh
# イメージのビルド
docker compose build

# DB 起動
docker compose up -d db

# DB 作成 (development / test)
docker compose run --rm web bin/rails db:create

# マイグレーション
docker compose run --rm web bin/rails db:migrate

# マスタデータ投入 (providers / plans / rates)
docker compose run --rm web bin/rails db:seed
```

## 開発サーバー

```sh
docker compose up
# http://localhost:3000
```

## テスト (RSpec)

```sh
docker compose run --rm web bundle exec rspec
```

## Lint / Format (Rubocop)

```sh
# チェックのみ
docker compose run --rm web bundle exec rubocop

# 自動整形 (安全な修正のみ)
docker compose run --rm web bundle exec rubocop -a

# 自動整形 (unsafe な修正も含む)
docker compose run --rm web bundle exec rubocop -A
```

## ヘルスチェックエンドポイント

```sh
GET /healthz
```

DB 接続を確認するヘルスチェックエンドポイント。
- 正常時: 200 OK, `{"status":"ok"}`
- DB 接続失敗時: 503 Service Unavailable, `{"status":"error"}`

本番: `https://d1qlohhwjtfdr1.cloudfront.net/healthz`

## 本番ビルド

```sh
docker build -f Dockerfile.production -t app:prod .
```

マルチステージビルド（builder / runtime）で最適化されたイメージを構築します。

## 本番環境変数

### 必須

- `DATABASE_URL`: PostgreSQL 接続 URL（例: `postgresql://user:pass@host:5432/db`）
  - 本番で未設定の場合、起動時に失敗します
- `SECRET_KEY_BASE`: Rails シークレット（64 hex 文字）
  - 本番で未設定の場合、起動時に失敗します

### オプション

- `CORS_ALLOWED_ORIGINS`: CORS 許可元（カンマ区切り）
  - 未設定なら CORS は無効化されます
  - 例: `https://example.com,https://app.example.com`
- `RAILS_ENV`: 環境指定（デフォルト: `production`）
  - Dockerfile.production で自動設定されます

### 本番起動例（ローカルテスト）

```sh
docker run --rm \
  -e RAILS_ENV=production \
  -e SECRET_KEY_BASE=$(openssl rand -hex 64) \
  -e DATABASE_URL="postgresql://postgres:password@host.docker.internal:5432/app_production" \
  -p 3000:3000 \
  app:prod
```

起動後、`curl http://localhost:3000/healthz` で疎通確認。

## 本番デプロイ (AWS ECS + Terraform)

インフラは Terraform で管理しています。詳細は `serverside_challenge_2/terraform/` を参照。

### 本番環境情報

| 項目 | 値 |
|---|---|
| CloudFront (API) | `https://d1qlohhwjtfdr1.cloudfront.net` |
| ECS クラスター | `enechange-coding-challenge-prod-cluster` |
| ECR リポジトリ | `866642010952.dkr.ecr.ap-northeast-1.amazonaws.com/enechange-coding-challenge-prod-app` |

### デプロイ手順

```sh
# 1. ECR にログイン
aws ecr get-login-password --region ap-northeast-1 \
  | docker login --username AWS --password-stdin \
    866642010952.dkr.ecr.ap-northeast-1.amazonaws.com

# 2. イメージをビルドして push (Apple Silicon の場合は --platform linux/amd64 必須)
docker buildx build --platform linux/amd64 \
  -f Dockerfile.production \
  -t 866642010952.dkr.ecr.ap-northeast-1.amazonaws.com/enechange-coding-challenge-prod-app:latest \
  --push .

# 3. ECS Service を強制的に最新イメージで再デプロイ
# (:latest タグは terraform apply では差分が出ないため --force-new-deployment を使う)
aws ecs update-service \
  --cluster enechange-coding-challenge-prod-cluster \
  --service enechange-coding-challenge-prod-app-service \
  --force-new-deployment \
  --region ap-northeast-1
```

### DB マイグレーション / Seed (ECS ワンオフタスク)

```sh
CLUSTER=enechange-coding-challenge-prod-cluster
TASKDEF=$(cd ../terraform && terraform output -raw ecs_task_definition_arn)
SUBNET=$(cd ../terraform && terraform output -json public_subnet_ids | jq -r '.[0]')
SG=$(cd ../terraform && terraform output -raw ecs_sg_id)

# マイグレーション
aws ecs run-task --cluster "$CLUSTER" --task-definition "$TASKDEF" \
  --launch-type FARGATE \
  --network-configuration "awsvpcConfiguration={subnets=[$SUBNET],securityGroups=[$SG],assignPublicIp=ENABLED}" \
  --overrides '{"containerOverrides":[{"name":"app","command":["bundle","exec","rails","db:migrate"]}]}' \
  --region ap-northeast-1

# Seed 投入 (冪等)
aws ecs run-task --cluster "$CLUSTER" --task-definition "$TASKDEF" \
  --launch-type FARGATE \
  --network-configuration "awsvpcConfiguration={subnets=[$SUBNET],securityGroups=[$SG],assignPublicIp=ENABLED}" \
  --overrides '{"containerOverrides":[{"name":"app","command":["bundle","exec","rails","db:seed"]}]}' \
  --region ap-northeast-1
```

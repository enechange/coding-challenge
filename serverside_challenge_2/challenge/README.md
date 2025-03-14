# 概要

このアプリケーションは、指定した契約アンペア数および使用量に基づき、各電力プランの料金比較を行います

# バージョン情報

- バックエンド
  - Ruby `3.1.2`
  - Rails `7.0.8`
- フロントエンド
  - vue `3.5.13`
  - vite `6.2.0`

# ファイル構成

```
.
├── docker-compose.override.yml # 開発環境の時に上書きで利用するDocker設定
├── docker-compose.yml          # 開発・本番環境のサービス定義とコンテナ設定
├── backend
│   └── Dockerfile              # バックエンド (Rails) アプリケーションのDockerfile
└── frontend
    ├── Dockerfile              # フロントエンド (Vue.js) アプリケーションの本番用Dockerfile
    └── Dockerfile.dev          # フロントエンド (Vue.js) アプリケーションの開発用Dockerfile
```

**※ バックエンド（Rails）のDockerfileは本番・開発用共通です**

# ローカル環境構築手順

1. Dockerコンテナを起動

```bash
docker compose up --build
```

2. データベースを作成

```bash
docker compose run web rails db:create
```

3. マイグレーション実行


```bash
docker compose run web rails db:migrate
```

4. シードデータの投入

```bash
docker compose run web rails db:seed
```

# 本番デプロイ手順(aws)

1. Copilotのインストール

以下を参考に環境に合わせて実施  
https://docs.aws.amazon.com/AmazonECS/latest/developerguide/copilot-install.html

2. AWS環境の初期設定

```bash
aws configure
```

3. フロントエンドのデプロイ

```bash
copilot svc deploy --name frontend --env prod
```

4. バックエンドのデプロイ

```bash
copilot svc deploy --name web --env prod
```

**※ `copilot/` ディレクトリが必要ですが、機密情報が含まれるためコミット対象に含めておりません**  
**そのため、本手順は参考としてご確認していただけたら幸いです。**  
**どうするのが正解かは分かりませんが、本当の運用であれば機密情報の管理はAWS Systems Manager 等で管理すべきかと思います。**

# アプリケーションへのアクセス

http://localhost:5173

# アプリケーションの利用方法

- 以下項目を入力する
  - 契約アンペア数(A)
  - 1ヶ月の使用量(kWh)
- 計算するを押下する
- 正常な値を入力した場合
  - 画面上に電力会社、プラン、料金(円)が表示される
- 不正な値を入力した場合
  - エラーが表示される

# データベース設計

## テーブル一覧
- `providers` (電力会社情報)
- `plans` (電力会社ごとのプラン)
- `electricity_charges_basic_rates` (プランごとの基本料金)
- `electricity_charges_usage_rates` (プランごとの従量料金)

## テーブル詳細

### `providers` (電力会社情報)
| カラム名 | 型 | 制約 | 説明 |
|:---|:---|:---|:---|
| `id` | `bigint` | PK, NOT NULL | ID (主キー) |
| `name` | `string` | NOT NULL, UNIQUE | 会社名 |
| `created_at` | `datetime` | NOT NULL | 作成日時 |
| `updated_at` | `datetime` | NOT NULL | 更新日時 |

---

### `plans` (電力会社ごとのプラン)
| カラム名 | 型 | 制約 | 説明 |
|:---|:---|:---|:---|
| `id` | `bigint` | PK, NOT NULL | ID (主キー) |
| `provider_id` | `bigint` | FK, NOT NULL | 電力会社ID (外部キー) |
| `name` | `string` | NOT NULL, UNIQUE | プラン名 |
| `created_at` | `datetime` | NOT NULL | 作成日時 |
| `updated_at` | `datetime` | NOT NULL | 更新日時 |

---

### `electricity_charges_basic_rates` (プランごとの基本料金)
| カラム名 | 型 | 制約 | 説明 |
|:---|:---|:---|:---|
| `id` | `bigint` | PK, NOT NULL | ID (主キー) |
| `plan_id` | `bigint` | FK, NOT NULL, ampereとの複合UNIQUE | プランID (外部キー) |
| `ampere` | `integer` | NOT NULL, planとの複合UNIQUE | 契約アンペア数(A) |
| `basic_rate` | `decimal` | NOT NULL | 基本料金 (円) |
| `created_at` | `datetime` | NOT NULL | 作成日時 |
| `updated_at` | `datetime` | NOT NULL | 更新日時 |

---

### `electricity_charges_usage_rates` (プランごとの従量料金)
| カラム名 | 型 | 制約 | 説明 |
|:---|:---|:---|:---|
| `id` | `bigint` | PK, NOT NULL | ID (主キー) |
| `plan_id` | `bigint` | FK, NOT NULL | プランID (外部キー) |
| `min_usage` | `integer` | NOT NULL | 電気使用量(kWh)の下限値 (境界値を含まない) |
| `max_usage` | `integer` | NULL許可 | 電気使用量(kWh)の上限値 (境界値を含む) |
| `unit_rate` | `decimal` | NOT NULL | 従量料金単価 (円/kWh) |
| `created_at` | `datetime` | NOT NULL | 作成日時 |
| `updated_at` | `datetime` | NOT NULL | 更新日時 |

# API

## 電力料金計算API

### エンドポイント

```
GET /electricity_prices
```

### リクエストパラメータ

| パラメータ | 必須 | 説明 | 例 |
| -- | -- | -- | -- |
| ampere | ○ | 契約アンペア数 (10/15/20/30/40/50/60のいずれか) | 30 |
| usage  | ○ | 使用量 (0以上の整数) | 200 |

### レスポンス

#### データ形式
- レスポンス形式: JSON
- データの並び順: ID の昇順で返却

---

#### 各項目の説明
- `provider_name` : 電力会社の名称
- `plan_name`: 電気料金プランの名称
- `price`: 料金 (円) 小数点以下は切り捨て

---

#### レスポンス例 (成功時)

```json
[
  {
    "provider_name": "東京電力エナジーパートナー",
    "plan_name": "従量電灯B",
    "price": "5648"
  },
  {
    "provider_name": "東京ガス",
    "plan_name": "ずっとも電気1",
    "price": "5890"
  }
]
```

#### レスポンス例 (エラー時)

```json
{
  "error": "アンペア数(ampere)は 10/15/20/30/40/50/60 のいずれかを指定してください"
}

```

# テストの実行

## フロントエンド
未実装

## バックエンド

rspecを導入しており、以下のコマンドでテスト実行できます

```
docker compose run web rspec
```

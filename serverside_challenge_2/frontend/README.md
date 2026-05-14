# 電気料金シミュレーター — フロントエンド

契約アンペアと月間使用量を入力すると、各社電力プランの料金を安い順に比較表示するシングルページアプリケーション。

関連 Issue: #17 / 親 Issue: #15

## 前提

- Node.js 20.9.0 以上（`.tool-versions` に `nodejs 20.19.0` を指定済み）
- npm

## セットアップ

```bash
cd serverside_challenge_2/frontend
npm install
cp .env.example .env.local
```

## 環境変数

| 変数 | 説明 | 例 |
|---|---|---|
| `NEXT_PUBLIC_API_URL` | Rails API のベース URL（末尾スラなし） | `http://localhost:3000` |

- ローカル: `.env.local` で `http://localhost:3000` を指定
- 本番: CloudFront の URL を CI/CD で注入（例: `https://xxx.cloudfront.net`）

## 開発サーバ起動

**Rails と Next.js を並行起動する必要があります。**

```bash
# ターミナル 1: Rails（challenge/ ディレクトリで）
CORS_ALLOWED_ORIGINS=http://localhost:3001 bin/rails s

# ターミナル 2: Next.js（frontend/ ディレクトリで）
npm run dev
```

ブラウザで http://localhost:3001 を開く。

> [!IMPORTANT]
> Rails 側の `CORS_ALLOWED_ORIGINS=http://localhost:3001` を忘れると CORS エラーになります。

## スクリプト一覧

| コマンド | 説明 |
|---|---|
| `npm run dev` | 開発サーバ起動（ポート 3001、Turbopack） |
| `npm run build` | 本番ビルド |
| `npm run start` | 本番サーバ起動（ポート 3001） |
| `npm run lint` | ESLint 実行 |
| `npm run format` | Prettier でフォーマット |
| `npm run format:check` | Prettier チェックのみ |
| `npm run test` | Vitest でテスト実行（1 回） |
| `npm run test:watch` | Vitest ウォッチモード |

## ディレクトリ構成

```
src/
├── app/
│   ├── globals.css          # Tailwind v4 CSS-first 設定
│   ├── layout.tsx           # ルートレイアウト（Server Component）
│   └── page.tsx             # 単一画面（Client Component）
├── components/
│   ├── simulation-form.tsx  # React Hook Form + Zod フォーム
│   ├── simulation-result.tsx # 結果一覧（loading / error / empty / success）
│   └── ui/                  # shadcn/ui 生成コンポーネント
├── lib/
│   ├── api.ts               # fetchSimulations()
│   ├── constants.ts         # VALID_AMPERES / MAX_KWH / API_BASE_URL
│   ├── schema.ts            # Zod バリデーションスキーマ
│   └── utils.ts             # shadcn の cn()
├── types/
│   └── api.ts               # API レスポンス型
└── __tests__/               # Vitest テスト
```

## API 仕様サマリ

```
GET /api/v1/electricity_bill_simulations?ampere={A}&kwh={kWh}
```

成功 200:
```json
{ "data": [{ "provider_name": "...", "plan_name": "...", "price": 8010 }] }
```
- `price` は整数（円）、price ASC → provider_name ASC → plan_name ASC で並ぶ

エラー 400:
```json
{ "errors": [{ "status": "400", "title": "Invalid Parameter", "detail": "...", "source": { "parameter": "ampere|kwh" } }] }
```

## テスト

```bash
npm run test
```

Vitest + Testing Library + jsdom で 17 テストを実行。
- `api.test.ts`: fetchSimulations の HTTP レイヤーテスト
- `simulation-form.test.tsx`: Zod バリデーション / submit フロー
- `simulation-result.test.tsx`: loading / error / empty / results の表示テスト

## 本番ビルド & デプロイ

### 本番環境情報

| 項目 | 値 |
|---|---|
| Vercel URL | `https://coding-challenge-umber-beta.vercel.app` |
| `NEXT_PUBLIC_API_URL` | `https://d1qlohhwjtfdr1.cloudfront.net` |

### Vercel デプロイ手順

1. Vercel プロジェクトの **Root Directory** を `serverside_challenge_2/frontend` に設定
2. Environment Variables に `NEXT_PUBLIC_API_URL = https://d1qlohhwjtfdr1.cloudfront.net` を追加
3. `npm run build` が通ることを確認してから deploy

## 既知の制約

- `VALID_AMPERES` / `MAX_KWH` は Rails 側（`challenge/app/models/concerns/electricity_bill_constants.rb`）と手書きで二重管理
- 再計算ボタンなし（フォームを再送信することで再計算）
- E2E テスト（Playwright）は採用しない

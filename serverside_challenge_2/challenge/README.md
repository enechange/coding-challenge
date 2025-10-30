## 概要

このリポジトリは「電気料金のシミュレーション」の課題提出用プロジェクトです。
指定された電力量と契約アンペア数を元に複数の電力プランを算出します。

## 使用技術について
- フロントエンド: Next.js(TypeScript)
- バックエンド: Ruby, Ruby on Rails
- 本番環境:
  - フロントエンド: Vercel
  - バックエンド: Cloud Run
  - データベース: Supabase(PostgreSQL)

### インフラ構成について
- 基本的に費用の掛からない構成で構築しております。
- Cloud Runはコールドスタートのため起動していない時はレスポンスが少し遅いのでご了承ください。

## 各環境のURLについて
### 本番環境
  - フロントエンド: https://coding-challenge-rouge-seven.vercel.app
  - バックエンド: https://energy-charges-118821896069.asia-northeast1.run.app
### 開発環境
  - フロントエンド: http://localhost:3001
  - バックエンド: http://localhost:3000

### 使い方
- https://coding-challenge-rouge-seven.vercel.app にアクセス
- 「契約アンペア数(A)」と「使用量(kWh)」を入力後「計算する」ボタンを押下
- 「プロバイダ名」「プラン名」「電気料金」情報が返ってくる

## ディレクトリ構成(ラフ)について
<pre>
challenge/
├── front/                # フロントエンド (Next.js / TypeScript)
│   ├── app/
│   ├── dot.env           # 共有用環境変数ファイル
│   ├── Dockerfile        # 開発環境用Dockerfile
│   └── ...
└── api/                  # バックエンド (Ruby on Rails API)
    ├── app/
    ├── dot.env           # 共有用環境変数ファイル
    ├── Dockerfile        # 開発環境用Dockerfile
    ├── Dockerfile.prd    # Cloud Run用Dockerfile
    └── ...
├── Makefile              # ビルド・起動コマンド群
├── compose.yml           # 開発用docker compose
├── compose.test.yml      # テスト用docker compose
</pre>

## 開発環境構築手順について
```bash
cd coding-challenge/serverside_challenge_2/challenge
cp api/dot.env api/.env
cp front/dot.env front/.env

make build
make up
make api-bash
rails db:migrate:reset db:seed
```

## 補足
- このリポジトリは課題提出用のため、`service.yaml`や`GithubActions`などの構成ファイルは作成しておりません。
- `Cloud Run`へは手動デプロイを実施しております。
- `docker build -f Dockerfile.prd --platform linux/amd64 -t (GARのリンク) .` でイメージをビルド
- `docker push (GARのリンク):latest` でビルドしたイメージにlatestタグをつけてGARにプッシュ
- `Cloud RunのUIから環境変数の設定および`Image`の指定をしております。`

- 各機能実装時の記録としてプルリクエストを随時作成しております。
- 確認手順などはプルリクエストへ詳細に記載させていただいております。

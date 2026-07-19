# ADR-0017: Git / PR 運用・ドキュメント方針（レビュー最適化）

## Status

Accepted

## Context

コード・コミット履歴・PRの内容そのものが提出物であり、レビューしやすさを意図的に設計する必要がある。

一方で提出形式（README）は「Forkして `/challenges/<account>/` にファイルを作成し、本リポジトリへPull Requestを作成する」という単一PR形式であり、「レビュー可能な単位にPRを分割する」という目的と一見矛盾する。また、設計判断の記録は当初Linear（個人的な設計管理ツール）に閉じており、ENECHANGE側のレビュアーはアクセスできない。

## Decision

### 1. PR構成: Fork内分割 → 最終的に単一PRで提出

自分のFork内では実装フェーズ単位で複数のPRを作成し、Fork内の `main` ブランチにマージしていく。最終的に、蓄積した `main` から upstream 本家リポジトリへ1本のPRを作成して提出する。Fork内の分割PRは段階的な設計・実装の反映を示す作業ログであり、提出形式（単一PR）とは矛盾しない。

### 2. コミット規約: Conventional Commits、外部ID非参照

`feat:` / `fix:` / `chore:` / `docs:` / `test:` 等のConventional Commitsを採用する。コミットメッセージ・PR説明のいずれにもLinearのissue番号は含めない。レビュアーがアクセスできない外部ツールのIDを参照させず、設計判断の根拠はリポジトリ内のADRドキュメント（本ディレクトリ）を正とする。

### 3. ブランチ命名: Conventional Commitsのtypeに揃える

`feature/xxx`, `chore/xxx` のように変更内容を表す命名にする。

### 4. PR分割単位（目安6PR）

1. `chore/tooling-setup` — プロジェクト初期化・TS/ESLint/Prettier/Tailwind設定
2. `feature/domain-and-ui-primitives` — ディレクトリ構成・ドメイン型・UIコンポーネント（+Storybook）
3. `feature/simulation-form` — カスケードフォーム本体・バリデーション・モックAPI連携
4. `feature/responsive-ux-polish` — レスポンシブ・アニメーション・disabled状態等の仕上げ
5. `test/coverage` — ユニット/E2Eテスト整備
6. `chore/ci-cd-and-docs` — CI/CD・README仕上げ

### 5. PRテンプレート

`.github/PULL_REQUEST_TEMPLATE.md` として以下を定義し、Fork内の全PRに適用する。

- 背景・目的
- 変更内容
- 関連ADR（`docs/adr/000X-xxx.md` へのリンク）
- 動作確認
- スクリーンショット（UI変更を伴う場合のみ）

### 6. README構成

1. 概要
2. デプロイURL（Vercel本番URL、Storybook URL）
3. 技術選定（React/Next.js選定理由の要約＋詳細はADRへのリンク）
4. 起動手順
5. 設計方針・ADR一覧（`docs/adr/` への目次リンク）
6. スコープ外・既知の制約（IE11非対応等）
7. テスト実行方法

### 7. ADR運用: Nygard形式、1ファイル1決定

`docs/adr/0001-xxx.md` のように4桁連番+ケバブケースタイトルのファイル名とし、各ファイルは以下の構成にする。

```
# ADR-0001: タイトル
## Status
## Context
## Decision
## Consequences
```

### 8. `.gitignore` / 生成物の扱い

Next.js標準の `.gitignore`（`node_modules/`, `.next/`, `.vercel/`）に加え、以下を明示的に追加する。CI実行時に生成し、リポジトリにはコミットしない。

- `storybook-static/`
- `coverage/`
- `playwright-report/`, `test-results/`
- `.env*.local`

## Consequences

- 正: コミット/ブランチ/PR運用ルールが決まっており、レビューしやすさを意図的に設計できている
- 正: ADRをリポジトリ内に配置することで、Linearにアクセスできないレビュアーにも設計判断の根拠が伝わる
- 正: Fork内分割PR運用により、提出形式（単一PR）を満たしつつ段階的な設計・実装の反映を示せる
- 負: Fork内のPR履歴と最終的な単一PRの粒度が異なるため、本家レビュアーは個々のFork内PRを直接参照できない（README・PR説明文からのADRリンクで補う）

# ADR-0007: 開発環境・ツールチェーン構築方針（Next.js / TS / Lint / Format）

## Status

Accepted

## Context

長期運用に耐える開発基盤を定義する。ビルド・型・静的解析・整形を揃え、環境差異とレビュー時の指摘コストを減らす。ビルドツールは [ADR-0002](./0002-nextjs-app-router.md)（レンダリング戦略、Next.js App Router）の決定に従属する。

「`/challenges/<name>/` 配下へのサブプロジェクト配置に伴う base path 設定」は、デプロイ先を Vercel に決定済みのため発生しない（Vite + GitHub Pages のようなサブパス配信ではなく、Vercel の Root Directory 機能でプロジェクトルートとして扱われ、独自ドメインのルートで配信される）。

## Decision

### パッケージマネージャ

- pnpm を採用
- bulletproof-react も pnpm を採用しており一貫性がある。Vercel も第一級でサポート

### Node バージョン固定

- `.node-version` と `package.json` の `engines` を併用
- `.node-version`: エディタ・ローカル開発・Vercel のランタイムバージョンを揃える
- `engines` + pnpm の `engine-strict`: `pnpm install` 時のバージョンミスマッチを検知する安全弁

### TypeScript strict 設定

```json
{
    "strict": true,
    "noUncheckedIndexedAccess": true,
    "noUnusedLocals": true,
    "noUnusedParameters": true,
    "noFallthroughCasesInSwitch": true
}
```

- `noUncheckedIndexedAccess` はマスターデータの `find` 等の探索結果に `undefined` の可能性を型で強制でき、[ADR-0004](./0004-domain-model.md)/[ADR-0005](./0005-form-validation.md) で確立した `null` セマンティクスの徹底に寄与
- `exactOptionalPropertyTypes` はライブラリ型との摩擦リスクが高いため見送り

### ESLint 構成

- `typescript-eslint` の `strictTypeChecked` + `eslint-config-next` + `eslint-plugin-jsx-a11y` + bulletproof-react 由来の import 境界ルール（`import/no-restricted-paths`、[ADR-0003](./0003-directory-structure.md)）を採用
- `strictTypeChecked` の `no-floating-promises` / `no-misused-promises`: [ADR-0006](./0006-api-abstraction.md) の非同期エリア判定の呼び出し漏れを静的検出
- `react-hooks/exhaustive-deps`: [ADR-0005](./0005-form-validation.md) のカスケードリセット（`watch` + `useEffect`）の正しさを検証
- `jsx-a11y`: [ADR-0018](./0018-accessibility.md)（a11y）の土台
- `eslint-config-next`: Core Web Vitals 関連ルールを含み [ADR-0012](./0012-performance.md)（パフォーマンス）と接続

### Prettier と ESLint の責務分離

- 完全分離方式を採用（`eslint-config-prettier` で ESLint 側の整形ルールを無効化。`eslint-plugin-prettier` は使わない）
- Prettier 設定: `singleQuote: true`, `tabWidth: 4`、他はデフォルト（`semi: true`, `trailingComma: "all"`, `printWidth: 80`）
- JSX属性のクォートは Prettier の `jsxSingleQuote` デフォルト値（`false`）に従いダブルクォートのまま維持する（`singleQuote` はJSX以外の文字列リテラルにのみ影響するため、両者は独立して制御される）

### EditorConfig / husky + lint-staged

- 両方導入する
- `.editorconfig` でエディタ非依存の一貫性を確保
- `husky` + `lint-staged` で commit 前に変更ファイルのみ ESLint/Prettier を自動実行。「フォーマット崩れのコミットをそもそも作らせない」ことで、CI（[ADR-0015](./0015-cicd-deploy.md)、検出して落とす）と役割分担する

### 環境変数

- 現時点では一切使用しない。`.env.example` 等の実ファイルも作らない
- [ADR-0006](./0006-api-abstraction.md) で「API ベース URL は相対パス直書き、環境変数化は不要」と決定済みであり、実際に必要になった時点で Next.js 標準規約（`NEXT_PUBLIC_` プレフィックスの有無でクライアント/サーバー公開範囲を区別）に従う、という方針のみ文章で残す

### `/challenges/<name>/` 配下への配置

- Next.js プロジェクト一式（`package.json`, `next.config.ts`, `src/` 等）をまるごと `/challenges/<name>/` 配下に置く
- Vercel の「Root Directory」設定で `challenges/<name>` を指定してビルドする（モノレポの1プロジェクトとして扱う、Vercel 標準機能）
- 特別な base path やビルド出力先のカスタム設定は不要

## Consequences

- 正: ツールチェーン一覧と各採用理由が整理されており、環境差異・レビュー指摘コストを抑えられる
- 正: `/challenges/<name>/` にサブプロジェクトとして配置する際のビルド/パス方針が確定している（Vercel Root Directory 機能で対応、特別な設定不要）
- 正: strict設定・ESLintルールがドメインモデルの `null` セマンティクスや非同期処理の正しさを機械的に検証する
- 負: `strictTypeChecked` の導入により初期のLintエラー対応コストが増えるが、長期的な品質担保を優先する

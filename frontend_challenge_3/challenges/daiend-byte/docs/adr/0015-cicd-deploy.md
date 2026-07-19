# ADR-0015: CI/CD・デプロイ設計（GitHub Actions / Vercel）

## Status

Accepted

## Context

「github-pages 等で閲覧できる環境が好ましい」との要件に応え、品質ゲートを自動化する。CI が通る PR はレビュー印象も良い。

[ADR-0002](./0002-nextjs-app-router.md) の決定により、本番想定アーキテクチャは Next.js（SSR/SSG 前提）。デモのホスティングも選定したアーキテクチャ通りに動く環境（Vercel）を使い、GitHub Pages 向けの static export のような「本番と異なる特別なビルド」は用意しない。GitHub Pages は [ADR-0010](./0010-storybook.md) で Storybook 専用のホスティング先として別途採用している。

## Decision

### CIチェック項目・順序

- `lint`（[ADR-0007](./0007-toolchain.md): ESLint+Prettier）、`typecheck`（`tsc --noEmit`）、`test`（[ADR-0014](./0014-test-strategy.md): Vitest単体/結合）、`build`（Next.jsビルド）を並列ジョブとして実行し、PRごとに1ワークフローとする
- E2E（Playwright）はブラウザインストールのセットアップが重いため、別ジョブとして分離する
- 全ジョブを並列実行することで、失敗時のフィードバックが早く、複数の問題を一度に把握できる

### Forkリポジトリでの適用範囲

- CI/CDは「自分のフォークリポジトリ内の開発フロー」を対象とする。本家リポジトリへの最終PRはCIの対象外とし、レビューは本家メンテナが手動で行う前提とする
- GitHub Actions Secretsはフォークからの本家へのPRには安全上の理由でデフォルトで渡されないため、`pull_request_target`等のリスクを伴う回避策は取らない
- 自分のフォークは自分が所有するリポジトリなので、Vercel連携もSecretsも問題なく設定でき、フォーク上でのCI実績とデプロイURLをPR説明文に記載すれば要件を満たせる

### デプロイ構成

- Vercel の GitHub 連携機能を使い、フォークリポジトリの Root Directory に `challenges/<name>` を指定してプロジェクトを作成する
- push/PRごとのプレビューデプロイ・PRへのコメント自動投稿はVercel標準機能に委譲し、GitHub Actions側でデプロイ処理を自前実装しない（[ADR-0007](./0007-toolchain.md)の「Root Directory指定のみ」という方針と一致）
- Lighthouse CI 等でデプロイ済みURLに対する処理が必要な場合も、`vercel deploy`をCLIで自前実行するのではなく、Vercelのデプロイステータス（`deployment_status`イベント）や `wait-for-vercel-preview` 等のActionでデプロイ完了とURLを検知する軽量な待機ステップを追加する形で対応する（デプロイの実行主体はVercel標準連携のまま変えない）

### キャッシュ・並列化戦略

- `actions/setup-node` の `cache: 'pnpm'` でpnpmストアをキャッシュ
- Playwrightのブラウザバイナリも `actions/cache` で別途キャッシュする（ダウンロードが数百MB単位で重く、キャッシュの効果が大きい）

### README掲載

- CI（GitHub Actions）のステータスバッジ、VercelのデプロイURL、Storybook（GitHub Pages）のURLを `challenges/<name>/README.md` の冒頭にまとめて掲載する
- README はリポジトリで最初に開かれるファイルであり、動作確認用リンクとCI健全性を一目で示せる。[ADR-0017](./0017-git-pr-workflow.md)（Git/PR運用）のPR説明文とも連動させる

### Lighthouse CI の組み込み

- 別ジョブとして、Vercelのプレビューデプロイ完了を待ってから、そのプレビューURLに対して実行する（デプロイ完了待機ステップを利用）
- ローカルビルドではなく実際にデプロイされた環境（Vercelのエッジ環境）に対して計測することで、本番相当のパフォーマンス値を得る
- [ADR-0012](./0012-performance.md) で決めた目標スコア（Performance 90点以上）をこのジョブの合否基準とする。[ADR-0018](./0018-accessibility.md) で追加したAccessibilityカテゴリの閾値（90点以上）も同ジョブで検証する

## Consequences

- 正: CIで回すチェック項目とワークフロー構成が決まっており、並列実行により早いフィードバックが得られる
- 正: デプロイ先とその選定理由（[ADR-0002](./0002-nextjs-app-router.md)との整合含む）が確定している
- 正: Vercel標準機能に委ねることでGitHub Actions側の自前実装を最小化し、保守コストを抑えている
- 負: 本家リポジトリへの最終PRはCI対象外のため、その時点でのコードの健全性はフォーク上のCI実績を根拠に示す間接的な担保となる

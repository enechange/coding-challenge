# 電気料金かんたんシミュレーション

[![CI](https://github.com/daiend-byte/coding-challenge/actions/workflows/ci.yml/badge.svg)](https://github.com/daiend-byte/coding-challenge/actions/workflows/ci.yml)

- **デモ（Vercel）**: [https://coding-challenge-rose-six.vercel.app/simulation/electricity](https://coding-challenge-rose-six.vercel.app/simulation/electricity)
- **Storybook（GitHub Pages）**: [https://daiend-byte.github.io/coding-challenge/](https://daiend-byte.github.io/coding-challenge/)

## 1. 概要

ENECHANGEフロントエンド課題（[frontend_challenge_3](../../README.md)）の提出物です。郵便番号→電力会社→プラン→契約容量というカスケード形式の出し分けを持つ、電気料金シミュレーション申込みフォームを実装しています。

## 2. デプロイURL

| 項目           | URL                                                                                                                                        |
| -------------- | ------------------------------------------------------------------------------------------------------------------------------------------ |
| 本番（Vercel） | [https://coding-challenge-rose-six.vercel.app/simulation/electricity](https://coding-challenge-rose-six.vercel.app/simulation/electricity) |
| Storybook      | [https://daiend-byte.github.io/coding-challenge/](https://daiend-byte.github.io/coding-challenge/)                                         |

## 3. 技術選定

フレームワークにはReactを採用しました。要件面（段階的な出し分けフォーム、リアルタイムバリデーション、型安全）はReact/Vueどちらでも実現可能なため、決め手にはせず、採用市場での人材確保のしやすさ・スケール時の保守性・エコシステムの持続性といった長期的な組織ドライバーを判断基準としています。詳細は[ADR-0001](./docs/adr/0001-react-selection.md)を参照してください。

レンダリング戦略にはNext.js（App Router）を採用しました。今後のアプリケーションの拡張を踏まえた妥当性を基準にしています。詳細は[ADR-0002](./docs/adr/0002-nextjs-app-router.md)を参照してください。

## 4. 起動手順

```bash
# Node.js 24.18.0 / pnpm 11.5.0以上を想定（.node-version / engines参照）
cd frontend_challenge_3/challenges/daiend-byte
pnpm install
pnpm dev
```

[http://localhost:3000](http://localhost:3000) を開いてください。

Storybookを起動する場合:

```bash
pnpm storybook
```

## 5. 設計方針・ADR一覧

設計判断はすべて[Architecture Decision Record](./docs/adr/)としてリポジトリ内に記録しています。

| ADR                                            | 内容                                                  |
| ---------------------------------------------- | ----------------------------------------------------- |
| [0001](./docs/adr/0001-react-selection.md)     | フロントエンドフレームワークにReactを採用する         |
| [0002](./docs/adr/0002-nextjs-app-router.md)   | レンダリング戦略にNext.js（App Router）を採用する     |
| [0003](./docs/adr/0003-directory-structure.md) | ディレクトリ構成（bulletproof-react準拠）             |
| [0004](./docs/adr/0004-domain-model.md)        | ドメインモデル設計（エリア→電力会社→プラン→契約容量） |
| [0005](./docs/adr/0005-form-validation.md)     | フォーム・バリデーション設計（React Hook Form + Zod） |
| [0006](./docs/adr/0006-api-abstraction.md)     | API抽象化・モック層の設計                             |
| [0007](./docs/adr/0007-toolchain.md)           | 開発環境・ツールチェーン構築方針                      |
| [0008](./docs/adr/0008-styling-tokens.md)      | スタイリング方針・デザイントークン設計                |
| [0009](./docs/adr/0009-ui-components.md)       | 共通UIコンポーネント設計                              |
| [0010](./docs/adr/0010-storybook.md)           | Storybook導入要否の検討                               |
| [0011](./docs/adr/0011-responsive-ux.md)       | レスポンシブ・UX方針（モバイルファースト）            |
| [0012](./docs/adr/0012-performance.md)         | パフォーマンス方針（バンドル・Core Web Vitals）       |
| [0013](./docs/adr/0013-seo.md)                 | SEO方針（メタ/OGP）                                   |
| [0014](./docs/adr/0014-test-strategy.md)       | テスト戦略                                            |
| [0015](./docs/adr/0015-cicd-deploy.md)         | CI/CD・デプロイ設計（GitHub Actions / Vercel）        |
| [0016](./docs/adr/0016-browser-support.md)     | 対応ブラウザ方針（IE11対象外）                        |
| [0017](./docs/adr/0017-git-pr-workflow.md)     | Git/PR運用・ドキュメント方針                          |
| [0018](./docs/adr/0018-accessibility.md)       | アクセシビリティ（a11y）方針                          |

## 6. スコープ外・既知の制約

- IE11は対応対象外です（[ADR-0016](./docs/adr/0016-browser-support.md)）
- サービスエリア判定は郵便番号の上1桁による仮実装です。サーバーサイドの本実装が完了次第、Route Handler（`src/app/api/check-service-area/`）を差し替える想定です（[ADR-0006](./docs/adr/0006-api-abstraction.md)）

## 7. テスト実行方法

```bash
# 単体・結合テスト（Vitest + React Testing Library + MSW）
pnpm test

# カバレッジ
pnpm coverage

# E2E（Playwright、実際のRoute Handlerに対して実行）
pnpm e2e
```

テスト方針の詳細は[ADR-0014](./docs/adr/0014-test-strategy.md)を参照してください。

# ADR-0010: Storybook 導入要否の検討

## Status

Accepted

## Context

[ADR-0009](./0009-ui-components.md)（共通UIコンポーネント設計）の検討中に、Storybook 導入の要否が論点として上がった。単一ADRの中で決着させるには重みがあるため、切り出して別途検討する。

## Decision

### 導入要否

- 導入する
- 規模（コンポーネント数8〜9個、単一機能）だけを見れば投資対効果は薄いが、[ADR-0003](./0003-directory-structure.md) で設計した将来のマルチエネルギー展開（`/simulation/gas` 等）を見据え、コンポーネントライブラリ運用を実務水準で最初から整備しておく判断とした

### フレームワーク統合

- `@storybook/nextjs`（公式 Next.js フレームワーク統合）を採用
- `next/image`, `next/font`, App Router のパスエイリアス（`@/`）, Tailwind CSS（`postcss.config.js`）を追加設定なしで解決できる

### カタログ化対象の範囲

- `components/ui/` 配下の presentational コンポーネント（`Input`, `Select`, `FieldWrapper`, `Button` 等）のみを対象とする
- `features/simulation/components/` の container コンポーネント（`ProviderSelect` 等）は `useFormContext` に依存しカスケード状態を持つため対象外。これらの動作確認は E2E（[ADR-0014](./0014-test-strategy.md)）で行う
- Storybook の強みは依存を切り離した単体表示にあり、それが活きる presentational 層に限定するのが妥当という判断

### `.stories.tsx` の配置規則

- bulletproof-react に倣い、コンポーネント本体と同じフォルダに co-location（`input.tsx` の隣に `input.stories.tsx`）
- 1ファイル内で主要な状態（Default / エラー時 / disabled 時等）を複数 export し、design.png の各コンポーネント（「エラーメッセージを表示するコンポーネント」等）の見た目を個別に確認できるようにする
- `@storybook/addon-a11y` の導入は [ADR-0018](./0018-accessibility.md)（a11y方針）で確定: 導入する

### デプロイ方式

- GitHub Actions で `storybook build` を実行し、`actions/upload-pages-artifact` + `actions/deploy-pages` で GitHub Pages に公開する
- 本体アプリは [ADR-0006](./0006-api-abstraction.md) で導入した Route Handler（サーバー実行が必要）のため GitHub Pages では動作せず Vercel を採用しているが、Storybook の `storybook build` は完全に静的な出力であり GitHub Pages の制約と技術的に矛盾しない
- 別の Vercel プロジェクトを追加する案より、外部アカウントを増やさず GitHub のみで完結する点、[ADR-0015](./0015-cicd-deploy.md)（CI/CD設計、GitHub Actions前提）に自然に統合できる点で優れる
- 本体アプリ = Vercel、Storybook = GitHub Pages と、技術的制約に応じてホスティング先を使い分ける

## Consequences

- 正: Storybook 導入要否の結論と根拠が文書化されている
- 正: presentational層のコンポーネントカタログとして、将来のマルチエネルギー展開時のコンポーネント再利用を支える基盤になる
- 正: 本体アプリとStorybookでホスティング先を使い分けることで、技術的制約（Route Handlerの有無）と矛盾しないデプロイ構成になる
- 負: 単一機能・少数コンポーネントの規模に対しては、Storybookのセットアップ・維持コストがやや過剰投資に見える可能性がある

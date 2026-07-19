# ADR-0012: パフォーマンス方針（バンドル・Core Web Vitals）

## Status

Accepted

## Context

モバイル前提の軽量なフォームとして、パフォーマンス目標を定め、設計段階から過剰依存を避ける。

## Decision

### 依存ライブラリの重量評価

bundlephobia の実測値（gzip後）:

| パッケージ          | サイズ   |
| ------------------- | -------- |
| react-hook-form     | 約12.7KB |
| zod v3.23.8         | 約14.0KB |
| zod v4.4.3          | 約60.3KB |
| @hookform/resolvers | 約0.5KB  |

- Zod は v4系を採用する（v3比で約46KB gzip重い）
- 採用理由: 将来のマイグレーションコストを避け、最新のエコシステムに追従することを優先。今回使用する機能（`.nullable()`, `.email()`, `.regex()`, `.superRefine()`, `z.coerce.number()`, `z.enum()`）自体は v3/v4 どちらでも利用可能で機能的な制約はないが、バンドルサイズよりも学習コスト削減・最新追従を優先する判断とした
- react-hook-form は約12.7KBと軽量で、依存関係も0件

### コード分割の要否

- 行わない
- 単一ページ・単一ルート（`/simulation/electricity`）の構成であり、Next.js App Router のルート単位自動分割で十分
- `next/dynamic` 等による追加の遅延読み込みは、対象となる大きな独立コンポーネント（モーダル・チャート等）が存在しないため不要
- 判断根拠（単一画面のため）を明記し、将来ページが増えた際の再検討ポイントとして残す

### Core Web Vitals 目標値

- Google推奨の「Good」しきい値をそのまま採用: LCP ≤ 2.5秒、CLS ≤ 0.1、INP ≤ 200ms
- CLS は [ADR-0011](./0011-responsive-ux.md)（エラー表示のレイアウトシフト対策、カスケード出現アニメーション）の設計で達成可能な水準
- LCP は画像を含まない単一ページフォームのため余裕を持って達成見込み
- INP はフォーム操作中心のUIで重い処理がないため大きく下回る想定
- 独自の厳格な基準は設けず、業界標準の説明しやすさを優先

### フォント読み込み戦略

- システムフォントスタック（`-apple-system, BlinkMacSystemFont, "Segoe UI", "Hiragino Kaku Gothic ProN", "Noto Sans JP", sans-serif`）を採用し、Webフォントは使用しない
- 日本語Webフォントは漢字を含みファイルサイズが大きくなりやすく、FOUT/FOIT によるレイアウトシフトのリスクもある
- design.png も特別なカスタム書体を要求しておらず、システムフォントで要件を満たせる

### 画像/アセットの最適化方針

- photographicな画像は使用しない（design.png にも存在しない）ため `next/image` の検討は不要
- アイコンは4種類（ドロップダウン矢印/エラー注意マーク/submitボタンの右矢印/郵便番号エリア判定中のスピナー）を手書きのインラインSVGコンポーネントとして `components/ui/icons/` にまとめる
- 新規アイコンライブラリ（react-icons, Font Awesome等）は導入しない
    - react-icons はツリーシェイクにより1アイコンあたりの追加コストは小さいが、4種類程度なら手書きで十分見通せる規模であり、新規依存追加による選定理由の説明コストも発生しない
    - 各アイコンは `currentColor` で実装し、[ADR-0008](./0008-styling-tokens.md) の色トークン（`accent`/`danger`/`text`）を Tailwind の `text-*` クラスからそのまま継承する
    - スピナーは `animate-spin`（Tailwind組み込み）と組み合わせる
- 再検討の目安: アイコン種類が6〜8を超える、または複雑な形状が必要になった時点でライブラリ導入を再検討する

### 計測手段

- Lighthouse CI を GitHub Actions に組み込み、PRごとに Core Web Vitals相当の指標を計測する（[ADR-0015](./0015-cicd-deploy.md) の GitHub Actions 前提にそのまま統合）
- `@next/bundle-analyzer` でビルド時のバンドル構成を可視化する（Zod v4採用によりバンドル構成の可視化価値が高い）
- 目標スコア: Lighthouse Performance カテゴリで90点以上

## Consequences

- 正: パフォーマンス目標値と計測手段が定義されており、CIで継続的に検証できる
- 正: ライブラリ選定がバンドル観点でも裏付けられている（Zod v4の重量増を認識した上での意図的な選択）
- 正: アイコンを手書きSVGにすることで、少数のアイコンに対して新規依存を増やさずに済む
- 負: Zod v4は v3比で約46KB gzip重く、目標スコア達成のマージンを狭める可能性がある。Lighthouse CIで継続監視することでリスクを緩和する

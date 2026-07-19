# ADR-0009: 共通 UI コンポーネント設計

## Status

Accepted

## Context

フォームを構成する再利用可能な UI 部品を洗い出し、propsインターフェイスと責務を設計する。design.png に「〜を表示するコンポーネント」という指示があり、部品分割が意図されている。

## Decision

### ネイティブ `<select>` の採用

- ネイティブ `<select>` を採用し、`appearance: none` を用いて枠線・角丸・背景・矢印アイコンをすべて Tailwind の CSS で明示的に上書きする
- 「箱の外見」（枠線色・角丸・矢印）は design.png を忠実に再現しつつ、クリック後に開く選択UI（OS標準ピッカー）はネイティブのまま保つ
- README「スマートフォンでの表示をメインに考え」に合致し、モバイルでのタッチ操作・a11y をブラウザ標準の実装に委ねられる
- カスタムリストボックス（Radix UI Select等）は a11y・モバイル操作の作り込みコストに見合わないため不採用

### React Hook Form との接続方式

- `register` ベースの接続を採用（`registration: Partial<UseFormRegisterReturn>` を props で受け取る）
- bulletproof-react の実装（[input.tsx](https://github.com/alan2207/bulletproof-react/blob/master/apps/nextjs-app/src/components/ui/form/input.tsx)）を参考にした、RHFの型は知るがフォームインスタンス自体には依存しない中間的な設計
- ネイティブ `<select>`/`<input>` を採用した以上、`Controller` を導入する技術的な理由がない
- shadcn/ui 由来の `Form`/`FormField`/`Controller` ベースの新パターン（Radix UI + class-variance-authority 依存）は不採用。a11y面の自動配線という利点はあるが、`FieldWrapper` 側で `useId()` を使い同等の `aria-describedby`/`aria-invalid` 配線を自前で行うことで補う（詳細は [ADR-0018](./0018-accessibility.md)）

### `cva`（class-variance-authority）の導入

- 導入しない。`clsx` + `tailwind-merge`（`cn` ユーティリティ）のみ採用
- `cva` は variant の組み合わせが多い場合に効果を発揮するが、本プロジェクトのコンポーネント（`Button` は実質1variant、`Input`/`Select` の状態分岐も2〜3個程度）はその複雑さに達していない
- `cn` は `className` prop でのスタイル上書きを安全にマージするための実用的な必要性から採用（bulletproof-react も同様）

### presentational / container の責務分離

- `components/ui/form/` に横断的な presentational コンポーネント（`Input`, `Select`, `FieldWrapper`, `RequiredBadge`, `ErrorMessage`, `HelpText`）を配置。RHFの型（`UseFormRegisterReturn`等）は知るが `useFormContext` 等のフックには依存しない
- `components/ui/button/` に汎用 `Button`（用途限定の `SubmitButton` ではなく、`type="submit"` を呼び出し側が指定する設計）
- `features/simulation/components/` に `ZipCodeInput`/`ProviderSelect`/`PlanSelect`/`CapacitySelect` 等の container 側コンポーネントを配置。`watch`/`setValue`/カスケードリセットロジック（[ADR-0005](./0005-form-validation.md)）はここに閉じ込める
- [ADR-0003](./0003-directory-structure.md) の import 境界ルール（`components` → `features` への参照禁止）と整合

### ディレクトリ粒度

- bulletproof-react の `components/ui/` 構造（1コンポーネント1フォルダ、コンポーネント本体 + `index.ts`）に準拠
- フォーム関連コンポーネント（`Input`/`Select`/`FieldWrapper`/`ErrorMessage`/`RequiredBadge`/`HelpText`）は密結合のため `components/ui/form/` にまとめて配置
- `.stories.tsx`（Storybook）は本ADRのスコープでは含めない（[ADR-0010](./0010-storybook.md)）

```
components/ui/
├── form/
│   ├── input.tsx
│   ├── select.tsx
│   ├── field-wrapper.tsx
│   ├── error.tsx
│   ├── required-badge.tsx
│   ├── help-text.tsx
│   └── index.ts
├── button/
│   ├── button.tsx
│   └── index.ts
└── section-card/
    ├── section-card.tsx
    └── index.ts
```

### Storybook 導入

- 本ADRのスコープから切り出し、[ADR-0010](./0010-storybook.md) で別途検討する

### props 設計の一貫性

- `FieldWrapper` が `label`/`required`/`error`/`helpText` を一括で受け取り、内部で `RequiredBadge`/`ErrorMessage`/`HelpText` を組み立てる
- `Input`/`Select` は `FieldWrapperPassThroughProps`（bulletproof-react由来の命名）を継承した拡張版として定義
- design.png の全フィールドが「バッジ＋ラベル → 入力 → エラー/説明」という一貫したレイアウトのため、Compound Components 的な柔軟性は不要と判断

## Consequences

- 正: コンポーネント一覧と各責務・propsが整理され、見た目とロジックの境界が明確になっている
- 正: bulletproof-reactの実装パターンに準拠しつつ、ネイティブHTML要素中心の設計によりa11y・モバイル対応をブラウザ標準実装に委ねられる
- 正: `cva`を導入しない判断により、現状の規模に対して過剰な抽象化を避けられる
- 負: `Controller`を使わない設計のため、将来カスタムUIコンポーネント（Radix UI等）を導入する際は接続方式の見直しが必要

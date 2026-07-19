# ADR-0018: アクセシビリティ（a11y）方針

## Status

Accepted

## Context

業務水準のフォームとして、支援技術・キーボード操作への配慮を加点要素ではなく品質の基礎として設計に織り込む必要がある。[ADR-0009](./0009-ui-components.md)で `FieldWrapper` が `useId()` を用いて `aria-describedby`/`aria-invalid` を自前配線する方針までは決まっていたが、具体的な配線ルールと検証手段は本ADRで確定する。

## Decision

### 1. コントラスト比: エラーテキスト専用色の新設

design.pngから実測した `danger: #E66059` を白背景でテキスト色に使うと、実測コントラスト比は約3.40:1でありWCAG AAの通常テキスト基準（4.5:1）を満たさない（非テキスト要素の基準3:1は満たす）。

エラーメッセージ等のテキスト用途には、4.5:1以上を満たす濃さに調整した `danger-text` トークンを新設する（[ADR-0008](./0008-styling-tokens.md)）。アイコンや枠線など非テキスト要素は `danger`（design.png実測色）をそのまま使う。`primary`（#3D5B97、白背景で約6.73:1）は追加調整不要。

### 2. エラーの伝達

- `Input`/`Select` に `aria-invalid={!!error}` を常時付与
- `aria-describedby` は `helpText` と `error` のidをスペース区切りで連結し、存在するもののみ含める
- `ErrorMessage` コンポーネントに `role="alert"` を付与し、DOM追加時にスクリーンリーダーへ自動通知する（`mode: 'onBlur'`、[ADR-0005](./0005-form-validation.md)と整合）

### 3. 必須項目の伝達

`Input`/`Select` に `required` 属性を付与し、`<form>` に `noValidate` を付与する。必須であることの伝達は `required` 属性自体に任せ（MDN準拠。`aria-required`はセマンティックHTML要素では非推奨で、`<div role="textbox">`等の非セマンティック要素向け）、ブラウザ標準バリデーションUIの発火のみ抑制することでRHF+Zod（[ADR-0005](./0005-form-validation.md)）のカスタムバリデーションフローと競合させない。

### 4. フォーカス管理

全インタラクティブ要素（`Input`/`Select`/`Button`）に `focus-visible:ring` を適用し、キーボード操作時のみ視認性の高いフォーカスリング（primary色）を表示する。Tab順はDOM順に任せ、`tabIndex` のカスタム制御は行わない。カスケードで新規出現するフィールドへのautofocusは行わない（[ADR-0011](./0011-responsive-ux.md)と整合）。

### 5. 郵便番号入力・Selectのラベリング

- 郵便番号は[ADR-0005](./0005-form-validation.md)で単一の7桁文字列フィールドとして確定済みのため、分割入力は検討対象外
- 各 `<select>` の先頭に `disabled` かつ `value=""` の非表示プレースホルダー用 `<option>`（例:「選択してください」）を配置し、未選択状態を支援技術にも明確に伝える

### 6. 検証手段

- `eslint-plugin-jsx-a11y`（[ADR-0007](./0007-toolchain.md)で導入済み）による静的解析
- Lighthouse CI（[ADR-0012](./0012-performance.md)/[ADR-0015](./0015-cicd-deploy.md)で導入済み）の `assertions` にAccessibilityカテゴリの閾値90点以上を追加
- Storybook `addon-a11y`（[ADR-0010](./0010-storybook.md)）を導入し、presentational層のコンポーネント単位でaxe-coreベースの違反を開発時に検知する
- E2E（Playwright, [ADR-0014](./0014-test-strategy.md)）へのaxe組み込みは、happy-pathのみという[ADR-0014](./0014-test-strategy.md)のスコープを超えるため見送る

## Consequences

- 正: a11y要件のチェックリストが定義されており、検証手段（lint / 自動監査）が方針として決まっている
- 正: エラーテキストのコントラスト問題を実測に基づいて発見・是正でき、WCAG AA基準を満たす
- 正: `required`属性+`noValidate`の組み合わせにより、ネイティブHTMLセマンティクスとカスタムバリデーションフローが競合しない
- 負: E2Eへのaxe組み込みを見送ったため、実際のブラウザ描画結果に対するa11y違反の自動検知はStorybook・Lighthouse CIの範囲に限定される

# ADR-0008: スタイリング方針・デザイントークン設計

## Status

Accepted

## Context

design.png の色・サイズ・スペーシングを再現しつつ、保守しやすいスタイリング基盤を決める。CSS手法の選定理由は課題要件（CSSライブラリ使用時は理由説明が必要）。

## Decision

### CSS 手法の選定

- Tailwind CSS を採用
- bulletproof-react の実リポジトリ（`apps/nextjs-app`）で Tailwind CSS（+ `tailwind-merge`, `tailwindcss-animate`, `@tailwindcss/typography`, `eslint-plugin-tailwindcss`）の採用を確認済み。一貫性のある技術選定
- デザイントークンを `tailwind.config.ts` に一元管理でき、Next.js との親和性も高い

### デザイントークン（色）

design.png から実測（ピクセルサンプリング）した値をそのまま採用:

| トークン     | 値        | 用途                                           |
| ------------ | --------- | ---------------------------------------------- |
| `primary`    | `#3D5B97` | submitボタン                                   |
| `accent`     | `#ED9B38` | セクション左ボーダー、ドロップダウン矢印       |
| `danger`     | `#E66059` | 必須バッジ、エラーメッセージ（非テキスト用途） |
| `border`     | `#DDDDDD` | input/select枠線、説明文コンポーネント背景     |
| `disabled`   | `#DDDDDD` | submitボタン非活性時の背景                     |
| `background` | `#F8F8F8` | ページ背景                                     |
| `surface`    | `#FFFFFF` | セクション背景                                 |
| `text`       | `#222222` | 基本テキスト色、submitボタン非活性時の文字色   |

命名はセマンティック（用途ベース）。色数が少なく、Tailwind標準スケール（50〜900）に寄せると実測にない値を推測で埋めることになるため見送り。

### トークンのDRY化（生値の一元管理）

`border` と `disabled` は同じ実測値（`#DDDDDD`）を異なる用途名で参照するため、`tailwind.config.ts` 内で生値を `gray` という用途非依存の定数として1箇所に定義し、両トークンがそれを参照する。

```ts
const gray = '#DDDDDD'; // design.png から実測した唯一のグレー値
colors: {
    border: gray,
    disabled: gray,
}
```

`border` トークンをそのままボタン背景に転用する案は、トークン名が実際の用途（ボタンの非活性状態）と一致せず意味的に誤解を招くため、別名トークン（`disabled`）を追加する形にしている。

### hover / active 状態色

- README「より良いUI/UXの実装・ご提案いただいても構いません」を踏まえ、インタラクティブ要素には状態色を用意する
- 全トークンに機械的に用意するのではなく、実際にインタラクティブな要素（`primary` = submitボタン）のみに限定
- `accent` / `danger` / `border` / `surface` / `background` / `text` は静的用途のため状態色なし
- hover/active は実測値からの目測ではなく、HSL明度調整（hover: -10%、active: -15%）で機械的に導出し、ADRに導出式を明記することで恣意的な色創作でないことを示す
- input/select/button のフォーカスリングは新規トークンを作らず `accent` の半透明版（`ring-accent/50`）で表現する。design.pngの「先月の電気代」input（フォーカス状態で描画されている）をピクセルサンプリングした結果、発光色がRGB(246,213,157)付近で、`accent`（`#ED9B38`）を白背景に約50%透過で重ねた色とほぼ一致したため。design.png上はボーダー内側ににじむ柔らかいぼかし（box-shadowのblur）だが、Tailwindの`ring`ユーティリティでは再現できないため、色の再現を優先し、ぼかし表現はスコープ外とする
- input/select は背景が白（`surface`）のため `ring-inset` でボーダー内側に描画してもリングが視認できるが、submitボタンは背景が塗りつぶしの `primary` で、内側にリングを描くと背景色に埋もれて視認性が落ちる。ボタンのみ `ring-inset` を付けず、ページ背景（`background`）側に外向きにリングを描画して視認性を確保する

### submitボタン非活性時の配色

- 薄いグレー背景（`disabled` = `#DDDDDD`）+ 濃い文字（`text` = `#222222`）を採用。コントラスト比 約11.71:1（WCAG AAA基準を満たす）
- 却下案:
    - 背景に `opacity` を適用する案: ボタン全体（背景+白文字）が同じページ背景色に向かって透過し、フェード後の背景と文字のコントラストが約1.9:1まで低下することが判明し不採用
    - 濃い背景（`text`=`#222222`）+白文字の案: コントラスト比は良好（約15.91:1）だが、活性時の紺ボタンと視覚的な強さがほぼ同等になり「非活性=控えめ」というUI慣習に反するため不採用

### フォントサイズ・余白・角丸の抽出精度

- README「色やサイズ感、スペーシングはできる限り再現してください」「忠実に再現していただく必要はございません」を踏まえ、Tailwind のデフォルトスケール（`text-sm`/`text-base`/`text-lg`/`text-xl`、4px刻みのspacing、`rounded`/`rounded-md`）に目視で最も近い段階を割り当てる
- 実測（テキスト高さ・ボックス境界のピクセルスキャン）により、階層関係（タイトル > セクション見出し ≈ 本文 > ラベル・補足文）を確認
- 色は識別性に直結し実測値を採用したが、フォントサイズ・余白・角丸は相対的な階層関係が再現できれば十分という判断で、精度の掛け方を使い分けた
- 例外として、必須バッジ（`RequiredBadge`）の文字サイズはdesign.png実測で10pxとなり、デフォルトスケールの最小段階 `text-xs`（12px）にも収まらない外れ値だった。この場合はコンポーネント側にアービトラリ値（`text-[10px]`）を書き捨てるのではなく、色トークン（`--color-*`）と同じ考え方で `@theme` に `--text-2xs`（0.625rem）を追加し、`text-2xs` という名前付きユーティリティとして一元管理する
- 同様に、必須バッジの文字間隔（letter-spacing）もdesign.png実測で約0.4em相当と、Tailwindデフォルトスケール最大の `tracking-widest`（0.1em）を大きく超える外れ値だった。この場合も新規トークンを増やすのではなく、他に `tracking-widest` の利用箇所がないことを確認した上で `@theme` の `--tracking-widest` を0.4emに上書きし、実測値に合わせている
- `Input`/`Select` のボーダー幅はdesign.png実測で4px（`section-heading.tsx` の `border-l-4` と同じ実測値）。`border-4` + パディング + フォントサイズの組み合わせでちょうど64pxとなるようにし、これをInput/Selectの標準サイズとする。郵便番号のみdesign.png上で48pxかつ3セル分割の特殊な構造のため、汎用`Input`ではなく専用コンポーネント（`ZipCodeInput`、[ADR-0009](./0009-ui-components.md)）として別に扱う
- submitボタンの高さもdesign.png実測で64pxとなり、Input/Selectと同じ高さだった
- ボタンの表示文字・Selectの選択値テキストは、1文字単位のグリフ高さ実測（ボタンの「結」・Selectの「東」がいずれも約18px）により、`text-base`(16px)ではなく`text-lg`(18px)相当と判明した。Tailwindのデフォルトスケールでは `text-lg` と `text-xl` の行高がどちらも28pxで共通のため、フォントサイズの選択によらずパディングは共通で64pxに合わせられる
    - `select.tsx`: `border-4`（8px）+ `py-3.5`（28px）+ `text-lg`（行高28px）= 64px
    - `button.tsx`: `py-4.5`（36px、ボーダーなし）+ `text-lg`（行高28px）= 64px
    - `py-3.5`/`py-4.5`はTailwind v4の`--spacing`ベースの動的スケール（0.25rem刻みの任意倍数を自動生成）で、アービトラリ値やカスタムトークンの追加なしに表現できる

### リセットCSS / ベーススタイル

- Tailwind の Preflight（組み込みリセット）をそのまま使用
- 追加のリセットCSSライブラリは導入しない。日本語フォント指定等が必要になれば `tailwind.config.ts` の `theme.fontFamily` で対応

### ダークモード

- スコープ外として明記し、実装しない
- README・design.png のいずれにもダークモード要件が存在せず、対応すると「design.png にない配色を創作する」ことになり、実測値からの誠実なトークン導出方針と矛盾するため

## Consequences

- 正: トークン一覧（色・タイポ・スペーシング）が定義され、CSS手法の選定理由が文書化されている
- 正: 生値の一元管理（DRY）により、実測値の変更が1箇所で完結する
- 正: submitボタン非活性時の配色はWCAG AAA基準を満たしつつ「非活性=控えめ」というUI慣習とも整合する
- 負: フォントサイズ・余白はTailwind標準スケールへの近似であり、design.pngとの完全一致ではない（README許容範囲内の判断）

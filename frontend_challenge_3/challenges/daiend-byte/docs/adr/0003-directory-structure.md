# ADR-0003: ディレクトリ構成（bulletproof-react の Next.js App Router 実例に準拠）

## Status

Accepted

## Context

bulletproof-react を設計ベースにする方針。Next.js App Router との組み合わせ方について、`github.com/alan2207/bulletproof-react` の `apps/nextjs-app`（App Router 実装）と `apps/nextjs-pages`（Pages Router 実装）をリポジトリの実ファイル・実コード・ESLint設定まで直接確認し、事実に基づいて構成を確定した。

確認した事実:

1. **App Router（`apps/nextjs-app`）**: `src/app/` はそのまま Next.js の App Router。Pages Router 版のような「`pages/`は再exportのみの薄い殻、実装は別レイヤー」という二重構造は不要（App Router はファイルの共配置が可能なため）
2. 各ルートセグメント内の `_components/`（アンダースコア始まりでルーティング対象外）に画面構成コンポーネントを置く。`page.tsx` 自体はデータ prefetch 程度に留める（例: `src/app/app/discussions/page.tsx` → `./_components/discussions.tsx` → `@/features/discussions/components/discussions-list`）
3. **feature に `index.ts` の barrel export は無い**。`@/features/discussions/components/discussions-list` のように深い import パスを直接使用。feature 内部の隠蔽は行わず、越境防止は ESLint ルールで機械的に強制する
4. import 境界は `eslint-plugin-boundaries` ではなく `eslint-plugin-import` の `import/no-restricted-paths` で強制されている（実際の `.eslintrc.cjs` で確認済み）:
    - feature 間の相互 import 禁止（各 feature は自分自身のみ import 可）
    - `src/app` → `src/features` の一方向（逆方向禁止）
    - `src/features` / `src/app` → 共有層（`components` `hooks` `lib` `types` `utils`）の一方向（逆方向禁止）
5. ファイル名・フォルダ名は `eslint-plugin-check-file` で kebab-case を強制（`src/app` 配下は Next.js の `[param]` 記法があるため対象外）
6. 共有層の実際の構成: `components/{ui,layouts,errors}` `config/` `hooks/` `lib/` `testing/`（MSWモック等）`types/` `utils/` `styles/`

### URL 戦略（ルーティング設計）

実プロダクトでは `/` は将来的に SEO ランディングページになる想定である（[ADR-0002](./0002-nextjs-app-router.md): SEO経由の自然検索流入が事業の生命線）。フォームを `/` に直接置くと、後でランディングページを作る際に URL を壊す移行が発生するため、フォームは独立したパスに配置する。

また、ENECHANGE は電気以外（ガス等）のシミュレーションに拡張する可能性があるため、シミュレーション種別を URL に含める設計とする。

```
/                          → 将来のSEOランディングページ用に予約。
                             今回のスコープでは未実装のため /simulation/electricity へ redirect
/simulation/electricity    → 本課題で実装する電気料金シミュレーション入力フォーム（実体）
/simulation/gas            → （将来・スコープ外）ガス料金シミュレーション
/simulation/electricity/result → （将来・スコープ外）結果ページ
```

- feature名 `simulation` と URL の第1セグメントが一致
- 種別（`electricity`, `gas`）を第2セグメントで区別し、将来の並列追加が自然に行える
- `/simulation/electricity` は動的データ取得が無いため Next.js の静的レンダリング（デフォルト）で完結する
- `/` と `/simulation/electricity` で別々の meta（ランディング訴求用 / フォーム用）を設定できる（[ADR-0013](./0013-seo.md) と連携）

## Decision

ディレクトリ構成:

```
src/
  app/
    layout.tsx
    page.tsx                            # "/" → "/simulation/electricity" への redirect
    simulation/
      electricity/
        page.tsx                        # "/simulation/electricity" 薄い層。_components を呼ぶだけ
        _components/
          simulation-page.tsx           # ページ構成（レイアウト・見出し等）
  components/
    ui/                                 # 共有UI（Button, Select等）
  config/
    paths.ts
  features/
    simulation/
      api/
        check-service-area.ts           # ADR-0006: エリア判定の抽象化
      components/
        zip-code-field.tsx
        provider-select.tsx
        plan-select.tsx
        capacity-select.tsx
      data/
        areas.ts                        # ADR-0004: マスタデータ・出し分けロジック
        providers.ts
        plans.ts
        capacities.ts
      hooks/
        use-zip-code-area-check.ts      # 郵便番号分割入力・エリア判定の状態管理
        use-cascade-resolution.ts       # カスケードの解決状況判定
      schemas/
        simulation-form-schema.ts       # ADR-0005: zodスキーマ
  hooks/
  lib/
  testing/                              # MSW等（ADR-0006/ADR-0014 と連携）
  types/
  utils/
```

feature 内の `data/` `schemas/` `hooks/` は本家実例（`api/` `components/` のみ）には無い拡張。`data/`・`schemas/` は [ADR-0004](./0004-domain-model.md)（マスタデータ・出し分けロジック）・[ADR-0005](./0005-form-validation.md)（zodスキーマ）の置き場所として、`hooks/` はコンポーネントから状態管理・副作用ロジックを分離するために、本課題のドメイン特性上必要なため追加した。

feature 名は `simulation` を採用（README の「シミュレーション」に対応し、電気・ガス等のエネルギー種別を横断する汎用的な命名）。エネルギー種別はドメインモデル上のパラメータとして扱い、feature を分割する粒度ではない。

採用する ESLint 設定（bulletproof-react の実設定に準拠）:

- `import/no-restricted-paths`: feature間相互import禁止 / `app→features`一方向 / `features,app→共有層`一方向
- `eslint-plugin-check-file`: ファイル名・フォルダ名 kebab-case 強制（`src/app`配下除く）
- `import/order`: import のグループ化・アルファベット順strict化
- `import/no-cycle`: 循環import禁止

featureが1つ（`simulation`）のみの現段階でも、[ADR-0002](./0002-nextjs-app-router.md) で「多ページ化する」と決めた前提があるため、ルールは最初から敷いておく（コストが小さく、後からの逸脱防止に効く）。

## Consequences

- 正: bulletproof-react の実証済み構成に準拠しつつ、Next.js App Router の規約と共存できる
- 正: URL戦略が事業の成長軌道（SEOランディング化・複数エネルギー種別への拡張）と整合する形で確定している
- 正: import境界がESLintで機械的に強制され、レビューコストを増やさずアーキテクチャの逸脱を防げる
- 負: feature内の `data/`/`schemas/` は本家にない独自拡張であり、bulletproof-reactを知る読み手には差分説明が必要

## References

- https://github.com/alan2207/bulletproof-react/tree/master/apps/nextjs-app
- https://github.com/alan2207/bulletproof-react/blob/master/apps/nextjs-app/.eslintrc.cjs
- https://github.com/alan2207/bulletproof-react/blob/master/apps/nextjs-app/src/app/app/discussions/page.tsx

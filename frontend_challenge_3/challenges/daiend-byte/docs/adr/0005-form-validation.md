# ADR-0005: フォーム・バリデーション設計（React Hook Form + Zod）

## Status

Accepted

## Context

リアルタイムバリデーション・依存フィールドのリセット・submit活性化制御を、宣言的かつ型安全に実装する基盤を設計する。

## Decision

### ライブラリ選定

- React Hook Form + Zod を採用
- RHF: 非制御コンポーネントベースで再レンダリング最小化、`watch` / `setValue` でカスケード制御が宣言的
- Zod: TypeScript ファーストのスキーマ定義、`@hookform/resolvers/zod` で RHF と統合

### スキーマ構造

- フラット構造（全フィールドをトップレベルに並べる）
- フィールド数が6〜8個でネストの恩恵が薄く、ドット記法による認知コスト増を避ける

### カスケードリセット戦略

- `watch` + `useEffect` パターンを各フィールドコンポーネント（`provider-select.tsx`, `plan-select.tsx`, `capacity-select.tsx`）に分散配置
- 各コンポーネントが自分の上流を watch し、変化時に下流をリセット
- 責務分散によりテスタビリティを確保

### バリデーション発火タイミング

- `mode: "onBlur"`（フォーカスを外したときに初回検証、以降は onChange で即時更新）
- 入力途中のエラー表示を防ぎつつ、リアルタイムバリデーション要件を満たす

### 郵便番号フィールド

- フォーム値は単一の `zipCode: string`（7桁結合）
- 入力欄には `inputMode="numeric"` を指定（[ADR-0011](./0011-responsive-ux.md)）。`type="text"` のまま維持し `type="number"` は使わない

### エリア判定とスキーマの関係（[ADR-0006](./0006-api-abstraction.md) で確定）

- エリア判定 (`checkServiceArea`) は非同期関数であり、`zip-code-field.tsx` の `onBlur` で呼び出され、結果を `areaId: AreaId | null` フィールドに `setValue` する
- `superRefine` は `checkServiceArea` を直接呼ばず、既に解決済みの `areaId` を同期的に参照してカスケード整合性を検証する

### 条件付きフィールドの型表現

- select 系フィールドは `.nullable()` を使用
- `null` = 値が明示的に存在しない（未選択 / フィールド不要）
- [ADR-0004](./0004-domain-model.md) の `null` セマンティクス（「下流フィールドが存在しない」）と一貫
- カスケード欄（電力会社/プラン/契約容量）は上流が未解決の間、フィールド自体を非表示にする方式を維持する（[ADR-0011](./0011-responsive-ux.md) で ENECHANGE 実サービスの「常時表示+無効化+案内文」パターンとの比較検討を行った上で、非表示方式の継続を確認）

### カスケードバリデーション

- `superRefine` でマスターデータとの整合性を一括検証
- 上流が invalid なら早期 return し、下流の検証をスキップ
- submit 時にスキーマ層でデータ整合性を保証

### エラーメッセージ管理

- バリデーションエラーメッセージ: Zod スキーマの各ルールに `message` を直接記述
- ビジネスロジック系メッセージ（「サービスエリア対象外です。」「シミュレーション対象外です。」）: コンポーネント側で制御（入力の誤りではなくビジネスロジックの結果）
- 通信失敗時のエラー（`hasAreaCheckError`）はこれらとは別の汎用メッセージとしてコンポーネント側で表示（[ADR-0006](./0006-api-abstraction.md)）
- 電気代・メールアドレス欄のエラー表示は領域を事前確保せず、瞬間的に挿入する方式を採用（[ADR-0011](./0011-responsive-ux.md)）

### submit ボタン活性化

- `formState.isValid` 一本で制御
- `superRefine` にカスケード整合性を含めているため、全状態をカバー可能
- 非活性時の視覚表現（薄いグレー背景+濃い文字）は [ADR-0008](./0008-styling-tokens.md)/[ADR-0011](./0011-responsive-ux.md) で確定

### 電気代フィールド

- `type="text"` + `inputMode="numeric"` を採用し、`type="number"` は使わない（[ADR-0011](./0011-responsive-ux.md)。スピナーUIや `e`/`+`/`-` 入力の副作用を避けるための現在のベストプラクティス）
- RHFの `valueAsNumber` オプション（`type="number"` 前提）は使用しない。文字列として受け取り、Zod の `z.coerce.number()` で数値に変換した上で `min(1000)` 等を検証する

    ```ts
    electricityBill: z.coerce
        .number()
        .min(1000, { message: '電気代を正しく入力してください。' });
    ```

- 空文字や非数値の入力は `z.coerce.number()` が `NaN` を生成するため、Zodの `z.number()` バリデーションが自動的に invalid と判定する

### メールアドレスバリデーション

- `z.string().email()` + `.regex(/.+@.+\..+/)` でドメイン部にドットを要求
- 一般消費者向けサービスのため TLD なしアドレスを弾く

### スキーマ概要

```ts
const simulationFormSchema = z
    .object({
        zipCode: z
            .string()
            .length(7)
            .regex(/^\d{7}$/),
        areaId: z.enum(['tokyo', 'kansai']).nullable(), // zip-code-field.tsx の onBlur で checkServiceArea の結果をセット
        providerId: z.string().min(1).nullable(),
        planId: z.string().min(1).nullable(),
        capacityValue: z.string().min(1).nullable(),
        electricityBill: z.coerce
            .number()
            .min(1000, { message: '電気代を正しく入力してください。' }),
        email: z
            .string()
            .email({ message: 'メールアドレスを正しく入力してください。' })
            .regex(/.+@.+\..+/, {
                message: 'メールアドレスを正しく入力してください。',
            }),
    })
    .superRefine((data, ctx) => {
        // areaId を起点に、マスターデータとのカスケード整合性検証
    });
```

## Consequences

- 正: RHF + Zod の組み合わせにより、型安全なバリデーションとカスケード制御を宣言的に実装できる
- 正: `null` セマンティクスが [ADR-0004](./0004-domain-model.md) のドメインモデルと一貫し、二重のフラグ管理が不要
- 正: カスケードリセットの責務を各フィールドコンポーネントに分散配置することでテスタビリティを確保
- 負: `superRefine` によるカスケード整合性検証はスキーマがやや複雑になるが、submitボタンの活性化制御を`formState.isValid`一本に単純化できる利点が上回る

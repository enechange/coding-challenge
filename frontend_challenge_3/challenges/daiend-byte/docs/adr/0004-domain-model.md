# ADR-0004: ドメインモデル設計（エリア→電力会社→プラン→契約容量の依存関係）

## Status

Accepted

## Context

電気料金シミュレーションフォームの中核となる、郵便番号→エリア→電力会社→プラン→契約容量のカスケード依存関係をデータ駆動の構造として表現する必要がある。

README の仕様:

- 郵便番号の上1桁でエリアを判定（1→東京電力エリア、5→関西電力エリア、それ以外→対象エリア外）
- エリアに応じて電力会社の選択肢を出し分け（各エリアに正規の電力会社＋「その他」）
- 電力会社に応じてプランを出し分け（「その他」選択時はシミュレーション対象外）
- プランに応じて契約容量を出し分け（関西電力従量電灯Aは契約容量を聴取しない）
- 全プランの最低料金は1,000円

関連: [ADR-0003](./0003-directory-structure.md)（ディレクトリ構成）、[ADR-0006](./0006-api-abstraction.md)（API抽象化）、[ADR-0005](./0005-form-validation.md)（フォームバリデーション）

## Decision

### 1. データ構造: ネストツリー型

エリアを起点に、電力会社→プラン→契約容量をネストしたツリー構造で表現する。

今回のデータは2エリア×各2社×各2プランの固定マスタであり、正規化やフラット化のメリットが出ない規模。ネストにすることで「上流を選んだら下流がそのまま取れる」という依存解決が構造そのもので表現できる。

コンポーネントはツリーを直接探索せず、accessor関数経由でアクセスする。accessor関数のシグネチャ（同期/async/hook）はデータ供給方式に依存するため、[ADR-0006](./0006-api-abstraction.md)で決定する。本ADRでは戻り値の型（ドメインモデルの型）のみを確定する。

### 2. ツリーのルートはエリア

郵便番号→エリアの変換ロジックはドメインモデルに含めない。READMEが「後々APIを用いてサーバーサイドにリクエストを送り判定する」と明記しており、将来APIに置き換わる。この変換は [ADR-0006](./0006-api-abstraction.md)（`api/check-service-area.ts`）の責務とする。

### 3. `null` = 下流フィールドが存在しない

ツリー全体を通じて統一したルール:

- `plans: null` → プラン選択フィールドを出さない（「その他」→「シミュレーション対象外です。」を表示、submit無効）
- `capacities: null` → 契約容量フィールドを出さない（関西電力従量電灯A → 正常続行）

メッセージの出し分けは「どの層の `null` か」で決まる。プロバイダ層の `null` は対象外、プラン層の `null` は聴取不要。別途フラグを持つ必要はない。

### 4. 契約容量は `string[]`

select の表示ラベルと値を兼ねる文字列配列（`'10A'`, `'6kVA'` 等）。今回のフォームは入力聴取のみで数値計算を行わないため、構造化（value/unit/label の分離）は不要。

kVAの範囲（6〜49kVA、1kVA刻み）はヘルパー関数 `generateKvaRange(from, to)` で生成する。44件のリテラル羅列は網羅性の検証が困難であり、仕様書の「6kVAから49kVAまで1kVA刻み」と1対1で対応する関数呼び出しの方が意図が明確。

### 5. プラン説明文

デザインにある「選択肢の説明文を表示するコンポーネント」に対応し、`Plan` 型に `description: string | null` を持たせる。プランの説明文はドメインエンティティに属する情報であり、将来API化した場合もプランのレスポンスに含まれるのが自然。

### 6. 最低料金は定数

全プラン一律のビジネスルールとして `MIN_ELECTRICITY_BILL = 1000` を定数定義する。プランごとに異なる仕様は現時点で存在しないため、プランの属性には持たせない。バリデーション（[ADR-0005](./0005-form-validation.md) の Zodスキーマ）はこの定数を参照する。

### 型定義

```ts
type AreaId = 'tokyo' | 'kansai';

type Area = {
    id: AreaId;
    name: string;
    providers: Provider[];
};

type Provider = {
    id: string;
    name: string;
    plans: Plan[] | null; // null = シミュレーション対象外
};

type Plan = {
    id: string;
    name: string;
    description: string | null;
    capacities: string[] | null; // null = 契約容量を聴取しない
};
```

### マスタデータ構造

```ts
export const MIN_ELECTRICITY_BILL = 1000;

function generateKvaRange(from: number, to: number): string[] {
    return Array.from({ length: to - from + 1 }, (_, i) => `${from + i}kVA`);
}

export const masterData: Record<AreaId, Area> = {
    tokyo: {
        id: 'tokyo',
        name: '東京電力エリア',
        providers: [
            {
                id: 'tepco',
                name: '東京電力',
                plans: [
                    {
                        id: 'tepco-juryou-b',
                        name: '従量電灯B',
                        description: null,
                        capacities: [
                            '10A',
                            '15A',
                            '20A',
                            '30A',
                            '40A',
                            '50A',
                            '60A',
                        ],
                    },
                    {
                        id: 'tepco-juryou-c',
                        name: '従量電灯C',
                        description: null,
                        capacities: generateKvaRange(6, 49),
                    },
                ],
            },
            {
                id: 'other-tokyo',
                name: 'その他',
                plans: null,
            },
        ],
    },
    kansai: {
        id: 'kansai',
        name: '関西電力エリア',
        providers: [
            {
                id: 'kepco',
                name: '関西電力',
                plans: [
                    {
                        id: 'kepco-juryou-a',
                        name: '従量電灯A',
                        description: null,
                        capacities: null,
                    },
                    {
                        id: 'kepco-juryou-b',
                        name: '従量電灯B',
                        description: null,
                        capacities: generateKvaRange(6, 49),
                    },
                ],
            },
            {
                id: 'other-kansai',
                name: 'その他',
                plans: null,
            },
        ],
    },
};
```

### ファイル配置（[ADR-0003](./0003-directory-structure.md) 準拠）

```
src/features/simulation/
  data/
    types.ts                    # Area, Provider, Plan 型定義
    master-data.ts              # マスタデータ定義 + generateKvaRange
    constants.ts                # MIN_ELECTRICITY_BILL
```

## Consequences

- 正: 上流の選択に応じて下流の選択肢が構造そのもので導出でき、出し分けロジックが単純になる
- 正: 「その他」「契約容量なし」の例外ケースが `null` という統一ルールで型レベルに表現され、コンポーネント側の分岐が一貫する
- 正: [ADR-0006](./0006-api-abstraction.md)（API抽象化）との責務分担が明確（このADRは型とマスタデータ、ADR-0006は取得方法と郵便番号→エリア変換）
- 負: `data/`/`schemas/` はbulletproof-react本家実例にない拡張であり、feature内の責務がやや増える

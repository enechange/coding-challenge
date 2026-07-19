# ADR-0006: API 抽象化・モック層の設計（サーバー差し替えを見越す）

## Status

Accepted

## Context

郵便番号のエリア判定は「後々 API でサーバーサイド判定するが、未完成のため仮ロジックで実装」と要件に明記。仮実装を、将来サーバーへ差し替え可能な**インターフェイス越し**に隠蔽する。

## Decision

### 仮APIの実体

- Next.js Route Handler（`app/api/check-service-area/route.ts`）として実装する
- フロントエンド先行開発時に、未完成のバックエンドの代わりに一時的なモックエンドポイントを立てる一般的なパターンとして位置づける。README の「サーバーサイドの実装が未完了であるため、仮で以下の判定で実装する」という状況を、実際の開発フローとして再現するもの
- Next.js API Routes（本物のサーバーサイド実行環境）を使う一方、要件「サーバーサイドの実装は不要です」は「本番品質のバックエンド実装は不要」の意味と解釈し、一時的なモックの設置とは区別する
- MSW は不採用（アプリの動作としては Route Handler が実際にレスポンスを返すため不要。テストでの利用可否は [ADR-0014](./0014-test-strategy.md) で判断）

### エリア判定インターフェース

- 非同期関数として定義: `checkServiceArea(zipCode: string): Promise<AreaId | null>`
- `features/simulation/api/check-service-area.ts` に配置
- 内部で Route Handler へ `fetch` する

### 呼び出し元と状態管理

- `checkServiceArea` の呼び出しは `zip-code-field.tsx` の `onBlur` イベントで行う
- 結果は `setValue("areaId", result)` で `areaId` という別フィールドに格納する（郵便番号バリデーションとエリア判定を分離）
- ローカル state で `isCheckingArea`（ローディング）・`hasAreaCheckError`（通信失敗）を管理
- 通信失敗時は「サービスエリア対象外」とは別の汎用エラーメッセージを表示し、意味の混同を避ける

### Route Handler のレスポンス設計

- 常に 200 OK を返し、ボディの `{ areaId: AreaId | null }` で結果を表現
- 「エリア対象外」（`areaId: null`）はビジネスロジック上の正常系であり、HTTP エラーステータスにはしない
- [ADR-0004](./0004-domain-model.md) の「`null` = 値なし」の規約と一貫

### 通信失敗の表現

- `res.ok` が `false` の場合は `checkServiceArea` 内で `throw`
- 呼び出し元（`zip-code-field.tsx`）が `try/catch` で捕捉し、`hasAreaCheckError` を立てる
- `null` の意味を「対象エリア外」という正常系専用に保つため、失敗は例外として明確に分離

### 差し替え境界

- バックエンド完成後は Route Handler ごと削除し、`checkServiceArea` 内の fetch 先 URL を実バックエンドへの絶対 URL に書き換える
- 呼び出し元コンポーネント（`zip-code-field.tsx`）は無変更で済む
- ベース URL は相対パスをハードコードし、環境変数化は行わない（実バックエンドの仕様が不明な現時点での環境変数化は時期尚早な抽象化と判断）

### API クライアント層

- 共通 fetch ラッパー（`lib/api-client` 等）は今は導入しない
- 現時点でエンドポイントが1つのみのため、共通化の恩恵が確認できない。2つ目の API 呼び出しが必要になった段階で検討する

### [ADR-0005](./0005-form-validation.md) との整合性

[ADR-0005](./0005-form-validation.md) で確定したスキーマに以下を反映:

- `areaId: AreaId | null` フィールドを追加
- `superRefine` は `checkServiceArea` を直接呼ぶのではなく、`zip-code-field.tsx` が事前に解決した `areaId` を同期的に参照してカスケード整合性を検証する

## Consequences

- 正: エリア判定のインターフェイスが定義され、仮ロジックがその裏に隠蔽される設計になっている
- 正: 「サーバー実装完了後に何を差し替えれば良いか」が明確（Route Handler 削除 + `checkServiceArea` の fetch 先変更のみ、呼び出し元は無変更）
- 正: `null` の意味を正常系専用に保つことで、通信失敗と「対象エリア外」の混同を防げる
- 負: 現時点で共通APIクライアント層を持たないため、2本目のAPIが必要になった時点でリファクタリングが発生する（意図的な先送り）

# ADR-0014: テスト戦略

## Status

Accepted

## Context

ロジックの正しさを担保しつつ過不足ないテスト範囲を定める。特にドメインロジック（出し分け・境界値バリデーション）は自動テストの価値が高い。

## Decision

### テストツール選定

- Vitest + React Testing Library（単体/結合テスト）
- Playwright（E2E）
- Vitest はESMネイティブ対応・高速性から、Jestより新規プロジェクトに適する。[ADR-0012](./0012-performance.md)でZod v4を選んだ「最新エコシステムへの追従」という方針とも一貫
- React Testing Library は「実装の詳細ではなくユーザー視点の振る舞い」を検証する思想で、[ADR-0005](./0005-form-validation.md)のフォームのカスケード挙動テストと相性が良い
- Playwright はNext.js公式が推奨するE2Eツール

### 単体テストの対象・境界値

以下をドメインロジックの単体テスト必須対象とする:

1. `checkServiceArea`（[ADR-0006](./0006-api-abstraction.md)）: 郵便番号先頭が `1`→東京、`5`→関西、それ以外→`null`。境界（`0`, `9`等）も含む
2. `generateKvaRange`（[ADR-0004](./0004-domain-model.md)）: `generateKvaRange(6, 49)` が44要素の配列を正しく生成するか、境界（`6kVA`, `49kVA`が含まれるか）
3. `simulationFormSchema` の `electricityBill`（[ADR-0005](./0005-form-validation.md)）: `999`→invalid、`1000`→valid の境界値
4. `simulationFormSchema` の `email`（[ADR-0005](./0005-form-validation.md)）: TLDなし（`user@example`）が invalid になるか、正常系（`user@example.com`）が valid になるか
5. `simulationFormSchema` の `zipCode`: 6桁/8桁（invalid）、7桁数字（valid）の境界
6. `superRefine` のカスケード整合性検証（[ADR-0005](./0005-form-validation.md)）: 東京エリア×関西電力プランのような不正な組み合わせが invalid になるか

これらは純粋関数・スキーマ単体のロジックであり、UIレンダリングを伴わずテストできるため実行速度が速く回帰検知の価値が高い。テストピラミッドの土台として厚く担保する。

### コンポーネント/結合テストの範囲とMSW

- React Testing Library + MSW（Mock Service Worker）で、カスケード挙動（郵便番号入力→エリア確定→電力会社欄出現、等の一連の流れ）を結合テストする
- MSW はテスト環境の `fetch` をインターセプトし、[ADR-0006](./0006-api-abstraction.md) で確定した Route Handler の代わりにモックレスポンスを返す。`checkServiceArea` の実装（本番と同じ `fetch` 呼び出し）を一切変更せずテストできる
- [ADR-0006](./0006-api-abstraction.md) で保留していた「MSW導入の要否」は、アプリの実行時（不採用、Route Handlerを使う）とは別に、**テストの実行時のネットワーク層モック**として採用する形で決着させた。MSWの `msw/node` によるテスト統合はKent C. Dodds（Testing Library作者）らが提唱する広く一般的なプラクティスであり、RTLの思想（振る舞いベースのテスト）とも地続き
- テスト専用のdevDependencyであり、[ADR-0012](./0012-performance.md)のバンドルサイズ方針（本番バンドル）には影響しない

### E2Eテストの範囲

- ハッピーパス1本（郵便番号入力→最後まで正しく入力→submitボタン活性化）のみPlaywrightで実装する
- MSWでモックしたネットワーク層ではなく、実際のRoute Handler（[ADR-0006](./0006-api-abstraction.md)）に対する本物の`fetch`が正しく動作するかを、結合テストとは別の観点で検証する
- README のモバイル表示重視を踏まえ、Playwrightのモバイルビューポート設定（`devices["iPhone 13"]`等）で実ブラウザでのタップ操作・レイアウトを確認する
- 全パターンのE2E網羅はせず、「本物のネットワーク境界を通した疎通確認」「モバイルビューポートでの実操作確認」という結合テストで代替できない価値に絞る

### カバレッジ目標

- `features/simulation/data`（マスターデータ・型）、`features/simulation/schemas`（Zodスキーマ）、`features/simulation/api`（`checkServiceArea`）を高カバレッジ対象とし、90%以上を目標とする
- `components/ui/` 等のpresentationalコンポーネントには数値目標を課さない（Storybookでの視覚確認、[ADR-0010](./0010-storybook.md)、が適切な検証手段）
- プロジェクト全体で一律のカバレッジ目標は設定しない。無意味なテスト（presentational層のカバレッジ稼ぎのためのスナップショットテスト乱用等）を誘発しないための判断

### CIとの連携

- テスト実行（`vitest run` / `playwright test`）はPRごとに実行するという前提のみ本ADRで確認
- 具体的なワークフロー設計（GitHub Actionsの記述内容、実行順序、キャッシュ戦略等）は[ADR-0015](./0015-cicd-deploy.md)（CI/CD設計）に委ねる

## Consequences

- 正: テスト層ごとの対象範囲と使用ツールが決まっており、ドメインロジック/境界値の一覧が明確
- 正: MSWをテスト専用に限定することで、本番バンドルサイズ（[ADR-0012](./0012-performance.md)）への影響を避けつつ結合テストの価値を得られる
- 正: E2Eをハッピーパス1本に絞ることで、実装コストと「本物のネットワーク境界での疎通確認」という独自価値のバランスを取っている
- 負: E2Eの異常系（サービスエリア対象外等）はカバーされないため、その分の回帰検知は単体/結合テストに委ねられる

# チャレンジ課題提出

チャレンジ課題を実装しました。

* 氏名: 佐々木 徹
* 課題期間: 2022/11/25 (金) - 2022/12/08 (木)


## 起動手順

1. Ruby 3.1.3 をインストール
1. 依存パッケージをインストール
    1. `bundle install`
1. DB をセットアップ
    1. `rake db:migrate`
    1. `rake import:plans`
    1. `rake import:basic_prices`
    1. `rake import:unit_prices`
1. テスト実行
    1. `rake test`
1. アプリケーションサーバー起動
    1. `rails server`

## 確認ページ

htts://challenge.tetsu.io/ に API 確認用のページをデプロイしています。
また、 API 仕様書は https://challenge.tetsu.io/docs/ で閲覧できます。

## 設計概要

一般的な MVC モデルなので特筆すべき点のみ記載します。

### モデルクラス

以下のモデルを定義しています。

* Plan
    * プラン情報を保持する
    * 契約アンペア数と使用料を引数に、電気料金を計算して返すメソッドを持つ
* BasicPrice
    * プランごと契約アンペア数ごとに基本料金の金額を保持する
* UnitPrice
    * プランごと区分ごとに 1kWh の単価を保持する

リレーションは以下の通りです。

* Plan : BasicPrice = 1 : n
* Plan : UnitPrice = 1 : n

### パラメータークラス

リクエストパラメーターとモデルの項目が一致していないのですが Active::Model の validate を使用したかったため `app/params` ディレクトリを作成し、パラメーターのバリデーションを担うクラスを作成しました。

### その他

ひな形は `rails new xxx --api` を使って作成しましたが、明らかに不要なディレクトリやコードは削除しています。


## +α

### フロントエンド

vue.js と Tailwind CSS を使って実装しています。

### API 仕様書

[OpenAPI](https://www.google.com/search?q=openapi3.0&oq=openapi3.0&aqs=chrome..69i57j69i59l3j0i30l3j0i10i30j0i30j0i10i30.4041j1j4&sourceid=chrome&ie=UTF-8) の記法で作成し、[Redoc CLI](https://redocly.com/docs/redoc/deployment/cli/) を使って HTML へ変換しています。


### 時間があれば追加したかったこと

* ページネーション機能
    * リクエストパラメーターで `page` を受け取り、特定件数ずつレスポンスする
* CRUD
    * プランや基本料金、単価を管理するページ

## 環境
- Ruby 3.1.2
- Rails 7.0.4
- MySQL

<br>
<br>

## 環境構築方法
1. .envファイルを作成し、下記を追加
```
DATABASE_DEV_PASSWORD = 'ご自身のパスワード'
DATABASE_DEV_USER = 'ご自身のユーザー'
DATABASE_DEV_HOST = 'ご自身のホスト'
```

2. DBを作成後、CSVファイルをcURLの通りDBにインポートする
3. rails sでサーバーを立ち上げ、料金計算のcURLを叩けば任意のレスポンスが返ってきます。

<br>
<br>

## 実装について
要件の通り、リクエスト（AとkWh）を受け取って、プランごとの電気料金（provider_name, plan_name, price）を返す実装になっております。（詳細は下記cURLをご参照ください）

データは/csvディレクトリ以下のCSVファイルを読み込むことでDBにインポート可能です。

<br>
<br>

## デプロイ
今週末（11/12~11/13）にAWSもしくはHerokuにデプロイ予定です。

<br>
<br>

## cURL
※ 現時点（11/10）の環境構築後のrails serverでのcURLになります。

```javascript
// 料金計算

curl --location --request POST 'http://localhost:3000/api/v1/suggests' \
--header 'Content-Type: application/json' \
--data-raw '{
    "A": 30,
    "kWh": 100
}'

```

<br>

以下のインポートファイルは/csv以下の該当csvファイルを読み込んでください。
```javascript
// Providersインポート

curl --location --request POST 'http://localhost:3000/api/v1/providers' \
--form 'file=@"/Users/jibiki/freespace/test1/csv/providers.csv"'
```


<br>

```javascript
// Plansインポート

curl --location --request POST 'http://localhost:3000/api/v1/plans' \
--form 'file=@"/Users/jibiki/freespace/test1/csv/plans.csv"'
```


<br>

```javascript
// Amperagesインポート

curl --location --request POST 'http://localhost:3000/api/v1/amperages' \
--form 'file=@"/Users/jibiki/freespace/test1/csv/amperages.csv"'
```


<br>

```javascript
// Kilowattosインポート

curl --location --request POST 'http://localhost:3000/api/v1/kilowattos' \
--form 'file=@"/Users/jibiki/freespace/test1/csv/kilowattos.csv"'
```

## 環境
- Ruby 3.1.2
- Rails 7.0.4
- MySQL 8.0.30

<br>
<br>

## 環境構築方法
1. .envファイルを作成し、database.ymlの環境変数を設定する。
2. DBを作成後、CSVファイルをcURLの通りDBにインポートする。
3. rails sでサーバーを立ち上げ、料金計算のcURLを叩けば任意のレスポンスが返ってきます。

<br>
<br>

## 実装について
要件の通り、リクエスト（AとkWh）を受け取って、プランごとの電気料金（provider_name, plan_name, price）を返す実装になっております。

データは/csvディレクトリ以下のCSVファイルを読み込むことでDBにインポート可能です。

<br>
<br>

## デプロイ先
AWS EC2にデプロイしました。

下記URLに任意のパラメータ（アンペア数→A、使用料→kWh）を設定することで、該当プランごとの電気料金を返します。

http://52.193.177.120/api/v1/electricity_charge_simulators?A=30&kWh=300


<br>
<br>

## cURL（AWS）
```terminal
// 料金計算

curl 'http://52.193.177.120/api/v1/electricity_charge_simulators?A=30&kWh=500'
```

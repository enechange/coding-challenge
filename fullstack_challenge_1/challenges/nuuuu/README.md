# nuuuu test app

## 開発マシンの要件

* 動作確認ずみOS: Ubuntu Linux 20.04 
* docker, docker-composeをインストールしておくこと
* yarnをインストールしておくこと  
* mysqlクライアントライブラリをインストールしておくこと(see https://github.com/brianmario/mysql2 )

## 起動方法

```
docker-compose -d # mysql 起動

yarn install

rails db:craete
rails db:migrate

rails s
```

## 機能と開発状況

* データインポート
    * CSVファイルをもとにinsertするロジック
        * [x] 家庭情報 `HouseUsers::ImportService`
        * [x] 発電状況 `EnergyHistories::ImportService`
    * ファイルをuploadしてinsertする画面 (insertするロジックを呼ぶ)
        * [x] 家庭情報  `GET /house_users/import`
        * [x] 発電状況  `GET /energy_histories/import`
* 可視化
    * [x] 家庭一覧 `GET /house_users`
    * [x] 特定家庭の発電状況グラフ  `GET /house_users/:house_user_id`
* その他
    * [ ] rails app部分のdocker化
    * [ ] test code

# nuuuu test app

## 開発マシンの要件

* 動作確認ずみOS: Ubuntu Linux 20.04 
* docker, docker-composeをインストールしておくこと
* ruby 3.0.0をインストールしておくこと  
* yarnをインストールしておくこと(動作確認済みver 1.22.5)  
* mysqlクライアントライブラリをインストールしておくこと(see https://github.com/brianmario/mysql2 )

## 起動方法

```
bundle install
yarn install

docker-compose -d # mysql 起動

rails db:craete
rails db:migrate

rails s # => loalhost:3000 で画面表示
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
* その他改良したほうがいい点
    * [ ] rails app部分のdocker化
    * [ ] test code
    * [ ] 発電状況テーブルに対する、用途に応じたインデックス設計(year, month別表示など)
    * [ ] rails new で作られた不要ファイルの削除
    * [ ] よきせぬエラー発生時のエラーページ表示
    * [ ] ロギング

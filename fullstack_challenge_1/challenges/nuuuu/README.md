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
        * [x] 家庭情報
        * [x] 発電状況
    * ファイルをuploadしてinsertする画面 (insertするロジックを呼ぶ)
        * [ ] 家庭情報
        * [ ] 発電状況
* 可視化
    * [x] 家庭一覧
    * [x] 特定家庭の発電状況グラフ
* その他
    * [ ] 見栄えを整える
    * [ ] rails app部分のdocker化

# nuuuu test app

## 開発マシンの要件

* OS: Ubuntu Linux 20.04 
* docker, docker-composeをインストールしておくこと
* mysqlクライアントライブラリをインストールしておくこと(see https://github.com/brianmario/mysql2 )

## 起動方法

```
docker-compose -d # mysql 起動

rails db:craete
rails db:migrate

rails s
```

## 機能と開発状況

* データインポート
    * CSVファイルをもとにinsertするロジック
        * [ ] 家庭情報
        * [x] 発電状況
    * ファイルをuploadしてinsertする画面 (insertするロジックを呼ぶ)
        * [ ] 家庭情報
        * [ ] 発電状況
* 可視化
    * [ ] 家庭一覧
    * [ ] 特定家庭の発電状況グラフ
* その他
    * [ ] rails app部分のdocker化

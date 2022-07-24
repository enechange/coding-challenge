# ENECHANGE株式会社様 技術課題
## 概要
- ユーザーから契約アンペア数(A)と1ヶ月の使用量(kWh)を受け取って、プランごとの電気料金を返すAPI


## API仕様

### URL

```
GET /api/v1/plans
```

### Request

| パラメータ | 内容 | 必須 | デフォルト値 | 最大値 |
|  ---  |  ---  |  ---  |  ---  |  ---  |
| ampere | 契約アンペア数（A） | 必須 | 10 | 60 |
| amount_of_use | 使用量 | 必須 | 0 | 999999 |

### Response

```
HTTP/1.1 200 OK
{
}
```


# 構成
- Ruby 3.0.0
- Rails 6.1.6

# 要件
## データは、CSVやYAMLなどのファイルで管理して読み込んでください。
- ファイルはご用意ください（CSVやYAML形式など）。
- ファイルの用意が必須の為、データベースでのマスタ管理を行うと二重管理になるので、データベースは利用しない。
- ActiveRecordを使っても、ActiveYamlを使っても、抽象化されたModelに変わりないので、将来的にデータベースに移行も可能

# データ構造
## 電力会社（provider）
- provider:プラン（現状 1:1）
- provider:基本料金【basic_charge】（1:n）
- provider:従量料金【commodity_charge】（1:n）

# 環境構築手順
## Cloud9へのRubyインストール

```
$ ruby -v
ruby 2.6.3p62 (2019-04-16 revision 67580) [x86_64-linux]
$ rvm list
$ rvm get stable
$ rvm list known
$ rvm install
$ ruby -v
ruby 3.0.0p0 (2020-12-25 revision 95aff21468) [x86_64-linux]
$ rvm --default use 3.0.0
$ rvm list
   ruby-2.6.3 [ x86_64 ]
=* ruby-3.0.0 [ x86_64 ]
```

## アプリケーション作成（Rails6.1系へのダウングレード）

```
$ gem list rails
$ gem install -v 6.1.6 rails
$ rails _6.1.6_ new . -O ｰB
$ npm install --global yarn
$ yarn --version
$ rails webpacker:install
$ rails s
```
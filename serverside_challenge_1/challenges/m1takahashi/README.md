# 構成
- Ruby 3.0.0
- Rails 6.1.6

# 要件
## データは、CSVやYAMLなどのファイルで管理して読み込んでください。
- ファイルはご用意ください（CSVやYAML形式など）。
- ファイルの用意が必須の為、データベースでのマスタ管理を行うと二重管理になるので、データベースは利用しない。
- ActiveRecordを使っても、ActiveYamlを使っても、抽象化されたModelに変わりないので、将来的にデータベースに移行も可能

# 制限事項
- 従量料金は、整数の範囲で指定する。最大値が定められない場合には、RubyのInteger型ではなく、将来利用する可能性があるデータベースのInteger型の最大値を指定する。
- 便宜的に、『2,147,483,647』ではなく、『2,000,000,000』とする

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
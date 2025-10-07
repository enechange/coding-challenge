# これは
電気料金のシミュレーションを行えるサービスです。

# 構成
- Back-end
    - Ruby 3.1.2, Ruby on Rails 7.0.8
- DB
    - PostgreSQL
- Front-end
    - erb, Stimulus, CSS
- Asset
    - importmap, propshaft
- Test
    - Rspec, FactoryBot, Shoulda Matchers
- Dev
    - annotate, rails-erd

# 開発環境
## 初回セットアップ
```sh
./scripts/setup.sh
```

- DB作成
- seedデータ作成
- railsサーバー起動

まで

## 電気料金のシミュレーション

http://localhost:3000/plans にアクセス

## 基本コマンド
### railsサーバー起動
```sh
docker compose up -d
```

### データベース初期化、seedデータ作成
```sh
docker compose run --rm web rails db:reset
```

### rspec実行
```sh
docker compose run --rm web rspec
```

# ドキュメントの更新

annotationの強制更新　※ 基本的にmigrate実行時に更新されるので通常は不要

```sh
docker compose run --rm web bundle exec annotate --force
```

`erd.pdf`の更新

```sh
docker compose run --rm web rake erd
```
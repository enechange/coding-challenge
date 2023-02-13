# サーバサイドチャレンジ

（ https://github.com/kenji7157/coding-challenge-rails/commits/master からコードを移動）

## 使用技術

- 言語: Ruby(3.1.0)
- フレームワーク: Rails(7.0.4)
- DB: PostgreSQL

## 動作確認

「契約アンペア数: 30,使用量: 650」の場合のリクエスト・レスポンスは以下の通り。

- リクエスト

```
curl -H "Content-Type: application/json" -X GET -d '{"ampere": 30, "kwh": 650 }' http://localhost:3000/api/v1/plans
```

- レスポンス

```
[
  {
    "provider_name": "東京電力エナジーパートナー",
    "plan_name": "従量電灯B",
    "price": 18709
  },
  {
    "provider_name": "Loopでんき",
    "plan_name": "おうちプランでんき",
    "price": 17160
  },
  {
    "provider_name": "東京ガス",
    "plan_name": "ずっとも電気１",
    "price": 17109
  },
  {
    "provider_name": "JXTGでんき",
    "plan_name": "JXTGでんき（旧myでんき）",
    "price": 16841
  }
]
```

## 環境構築

- Docker を使用する場合は「1. Docker を使った環境構築」を参照
- ローカルで構築する場合「2. ローカルで環境構築」を参照

### 1. Docker を使った環境構築

#### 1.0 前提

- docker・docker-compose コマンドが使用できること

```
$ docker -v
Docker version 20.10.14, build a224086
$ docker-compose -v
docker-compose version 1.29.2, build 5becea4c
```

#### 1.1 環境変数ファイルの作成

- `.env.docker`の作成

```
$ cp .env.sample .env.docker
```

- `.env.docker`を修正

```
$ vi .env.docker
POSTGRES_HOST="db"
POSTGRES_USER="postgres"
POSTGRES_PASSWORD="password"
```

#### 1.2 Docker イメージの作成

```
$ docker-compose build --no-cache
```

#### 1.3 コンテナの作成・起動

```
$ docker-compose up -d

# 初期データ投入
$ chmod +x ./docker-setup.sh
$ ./docker-setup.sh
```

#### 1.4 動作確認

- http://localhost:3000/ にアクセスして画面が開けること
- 上記確認後に、以下を実行しシミュレーション結果が得られていれば環境構築完了

```
$ curl -H "Content-Type: application/json" -X GET -d '{"ampere": 30, "kwh": 120 }' http://localhost:3000/api/v1/plans
```

#### 1.5 Tips

・コンテナの停止

```
$ docker-compose stop
```

・コンテナの起動（初回環境構築後は、以下のコマンドで開発サーバを起動するだけでよい）

```
$ docker-compose start
```

- コンテナに入る

```
$ docker-compose exec web bash
```

### 2. ローカルで環境構築

#### 2.0 前提

- postgreDB が入っていること
- ruby 3.1.0 が使えること

#### 2.1 環境変数ファイルの作成

```
$ cp .env.sample .env.development
```

#### 2.2 gem のインストール

```
$ bundle install --path vendor/bundle
```

#### 2.3 データベースの構築

```
$ bin/rails db:create RAILE_ENV=development
Created database 'coding_challenge_rails_development'
Created database 'coding_challenge_rails_test'
```

#### 2.4 マイグレーションの実行

```
$ bin/rails db:migrate
```

#### 2.5 初期データの投入

```
$ bin/rails provider:import
$ bin/rails plan:import
$ bin/rails basic_charge:import
$ bin/rails commodity_charge:import
```

#### 2.6 動作確認

```
# 開発サーバの起動
$ bin/rails s

# 開発サーバの起動完了後に以下を実行してシミュレーション結果が取得できれば環境構築完了
$ curl -H "Content-Type: application/json" -X GET -d '{"ampere": 30, "kwh": 120 }' http://localhost:3000/api/v1/plans
```

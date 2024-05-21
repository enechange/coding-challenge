## 環境構築
### 前提条件
webコンテナでDBの作成とマイグレーション、初期データを入れておくことが前提条件となります
```
docker compose up
docker compose run --rm web rails db:create db:migrate
docker compose run --rm web rails db:seed
```

### URL
`docker comopse up`後に以下URLにアクセスすることで画面確認ができます

```
http://localhost:3001/
```

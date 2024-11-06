## 環境構築
- Dockerの起動
```sh
$ cd serverside_challenge_2/challenge
$ docker compose build
$ docker compose up
$ docker exec -it challenge-api /bin/bash
```

- データベースの初期化
```sh
root@a35275a66e97:/app# rails db:create
root@a35275a66e97:/app# rails db:migrate
root@a35275a66e97:/app# rails db:seed
```

- アプリケーションの実行
  ブラウザにて以下のURLにアクセス  
  http://localhost:5173/

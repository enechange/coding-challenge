# Docker＆Laravel環境構築手順

1. git clone後、サブモジュール(laradock)をclone
```.bash
$ cd coding-challenge
$ git submodule update --init --recursive
```

2. laradockディレクトリ内の.env.exampleをコピーして.env作成
```.bash
$ cd coding-challenge/serverside_challenge_1/challenges/big-noble/laradoc
$ cp .env.example .env
```

3. .envの`APP_CODE_PATH_HOST`を書き換え
```
- APP_CODE_PATH_HOST=../
+ APP_CODE_PATH_HOST=../source
```

4. dockerコンテナ立ち上げ
```.bash
$ docker-compose up -d nginx mysql phpmyadmin
```

5. laravel composer install & key generate
```.bash
$ docker-compose exec --user=laradock workspace composer install
$ docker-compose exec --user=laradock workspace cp .env.example .env
$ docker-compose exec --user=laradock workspace php artisan key:generate
```

6. 疎通確認  
   http://localhost/api/plan/index?ampere=10&use_power=100 にアクセス

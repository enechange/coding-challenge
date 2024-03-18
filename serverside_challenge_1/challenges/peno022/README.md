# 開発環境での動作確認方法

Docker が起動している状態で実行してください。

1. リポジトリを clone する。

   ```bash
   $ git clone https://github.com/peno022/coding-challenge.git
   ```

2. master ブランチで、coding-challenge/serverside_challenge_1/challenges/peno022 のディレクトリに移動して、コンテナ起動コマンドを実行する。

   ```bash
   # make up を実行すると、コンテナをビルドして docker compose 環境が起動します
   $ cd coding-challenge/serverside_challenge_1/challenges/peno022
   $ make up
   ```

3. ローカルコンテナに接続し、開発環境でアプリケーションを起動するためのコマンドを実行する。

   ```bash
   # コンテナの中に入る
   $ make login

   # DB 等のセットアップ
   $ bin/setup

   # rails server の起動
   $ bin/rails s -p 3000 -b '0.0.0.0'
   ```

4. 別なターミナルで curl コマンド等によるリクエストを実行し、APIのレスポンスが返ってくることを確認する。

    ```bash
    $ curl 'http://localhost:3000/api/electricity_plan_simulations?contract_amperage=40&consumption=100'
    # => [{"provider_name":"東京電力エナジーパートナー","plan_name":"従量電灯B","price":3132},{"provider_name":"Loopでんき","plan_name":"おうちプラン","price":2640},{"provider_name":"東京ガス","plan_name":"ずっとも電気1","price":3511},{"provider_name":"JXTGでんき","plan_name":"従量電灯Bたっぷりプラン","price":3132}]
    ```

5. （動作確認終了時）コンテナを停止する。

   ```bash
   $ make down
   ```

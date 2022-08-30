# Starting API
hey tech camp ではシステムの実装に用いるため Web API の参照実装を <https://github.com/heyinc/heytechcamp-2022/tree/main/api> で提供しています。
参照実装を使わずにシステムを実装しても良いですが、Web API 以外に注力したい場合はこちらの実装を利用しても良いです。
ここではその Web API 参照実装の使い方を説明します。

## API の利用方法
API は heytechcamp サーバ、もしくはローカル開発環境上で動かすことを想定しています。

以下では heytechcamp サーバ上で API を起動する方法、ローカルで API を起動する方法をおおまかに説明しています。
　
### heytechcamp サーバで API を起動する方法
heytechcamp サーバではデータ取り込み済みの MySQL が動いており、起動するだけで API 経由で値を取得可能です。

heytechcamp サーバにログインすると存在する `heytechcamp-2022/api/` ディレクトリに移動し `./bin/setup` 実行後、 `./bin/rails s` で Rails を起動できます。

```console
stores@internship-000:~/heytechcamp-2022/api$ ./bin/setup
...
stores@internship-000:~/heytechcamp-2022/api$ ./bin/rails s
=> Booting Puma
=> Rails 7.0.3.1 application starting in development 
=> Run `bin/rails server --help` for more startup options
Puma starting in single mode...
* Puma version: 5.6.4 (ruby 3.1.2-p20) ("Birdie's Version")
*  Min threads: 5
*  Max threads: 5
*  Environment: development
*          PID: 10509
* Listening on http://127.0.0.1:3000
* Listening on http://[::1]:3000
Use Ctrl-C to stop
```

API には curl コマンドなど適当なクライアントでアクセスできます。

```console
$ curl http://127.0.0.1:3000/users/60cc1ec159110d2e3f30036c
{"id":"60cc1ec159110d2e3f30036c","name":"hogelog",...}
```

また、SSH 接続に `LocalForward 13000 localhost:3000` のように LocalForward 設定を追加することで heytechcamp サーバ上で動く API に対し <http://localhost:13000> のような URL でアクセス可能になります。

### ローカルで API を起動する方法
ここではローカルで MySQL、API を起動する方法を説明します。

#### データの取り込み
ここではローカルの Docker Compose で起動した MySQL に先に説明した stores-dump.sql を取り込む方法を説明します。

以下の作業はすべて手元に clone してきた heytechcamp-2022 リポジトリの api/ ディレクトリ以下で実施する想定です。

- stores-dump.sql を tmp/ 以下に移動（or コピー）します
- 以下のように docker-compose で起動した MySQL の stores_development データベースの中に取り込みます
```console
$ docker compose up --build
$ ./bin/setup
Created database 'stores_development'
Created database 'stores_test'
$ mysql -ustores -h127.0.0.1 -P4306 -ppassword < tmp/stores-dump.sql
...
```

stores-dump.sql はサイズが大きいため取り込みにもそれなりの時間がかかります。
mysql コマンドで接続し `show tables;` で10個のテーブルが表示されていれば取り込み完了です。

```console
$ mysql -ustores -h127.0.0.1 -P4306 -ppassword stores_development
...
mysql> show tables;
+------------------------------+
| Tables_in_stores_development |
+------------------------------+
| customer_addresses           |
| customers                    |
| inventory_units              |
| item_images                  |
| item_variations              |
| items                        |
| orders                       |
| sales_channels               |
| stores                       |
| users                        |
+------------------------------+
10 rows in set (0.01 sec)
```

#### API の起動
データベースの取り込みが完了し `./bin/rails s` でサーバを起動すると、API 経由でデータを表示できるようになっています。

```console
$ ./bin/rails s
=> Booting Puma
=> Rails 7.0.3.1 application starting in development 
=> Run `bin/rails server --help` for more startup options
Puma starting in single mode...
* Puma version: 5.6.4 (ruby 3.1.2-p20) ("Birdie's Version")
*  Min threads: 5
*  Max threads: 5
*  Environment: development
*          PID: 47012
* Listening on http://127.0.0.1:3000
* Listening on http://[::1]:3000
Use Ctrl-C to stop
```

curl コマンドやブラウザなど適当なクライアントでアクセスし JSON のレスポンスが返ってくるようになると、API の起動にも成功しています。

```console
$ curl -s http://localhost:3000/users/60cc1ec159110d2e3f30036c | jq
{
  "id": "60cc1ec159110d2e3f30036c",
  "name": "hogelog",
  ...
}
```

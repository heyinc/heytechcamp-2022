# Explore MySQL
heytechcamp サーバでは MySQL が動いており、STORES のようなサービスを作成するためのデータが格納されています。
ここではそのデータにアクセスする方法について説明します。

## MySQL へのアクセス
heytechcamp サーバの MySQL には SSH 経由でしかアクセスできません。

heytechcamp サーバに SSH でログインし `mysql -ustores stores` して以下のような表示になれば stores データベースにアクセスできています。

```console
stores@awesome-server:~$ mysql -ustores stores
...
mysql> 
```

stores データベースには STORES のようなサービスを構成するのに必要なデータが格納されており、自由にアクセス可能です。

```console
mysql> show tables;
+--------------------+
| Tables_in_stores   |
+--------------------+
| customer_addresses |
| customers          |
...
+--------------------+
10 rows in set (0.01 sec)

mysql> select * from users where email = "hogelog@hey.jp";
+--------------------------+---------+----------------+---------------------+---------------------+
| id                       | name    | email          | created_at          | updated_at          |
+--------------------------+---------+----------------+---------------------+---------------------+
| 60cc1ec159110d2e3f30036c | hogelog | hogelog@hey.jp | 2021-06-18 04:19:14 | 2021-06-22 03:34:56 |
+--------------------------+---------+----------------+---------------------+---------------------+
1 row in set (0.06 sec)
mysql> select s.* from users u join stores s on u.id = s.user_id where email = "hogelog@hey.jp";
+--------------------------+---------------+--------------------------+---------------------+---------------------+
| id                       | name          | user_id                  | created_at          | updated_at          |
+--------------------------+---------------+--------------------------+---------------------+---------------------+
| 60cc1ec259110d2e3f300370 | hogelog STORE | 60cc1ec159110d2e3f30036c | 2021-06-18 04:19:14 | 2021-12-21 10:00:16 |
+--------------------------+---------------+--------------------------+---------------------+---------------------+
1 row in set (0.08 sec)

mysql> 
```

### MySQL ダンプデータの取り込み
stores データベースのデータは heytechcamp サーバのホームディレクトリに `stores-dump.sql.gz` としてダンプされています。
こちらのデータを手元にコピーしてきてローカルの MySQL などに取り込むことも可能です。

```console
$ scp heytechcamp.internship-000:stores-dump.sql.gz .
 ...
$ gunzip stores-dump.sql.gz
$ mysql -uroot
...
mysql> create database stores2;
Query OK, 1 row affected (0.00 sec)

mysql> use stores2;
Database changed
mysql> source stores-dump.sql
...
```

### MySQL ポートフォワーディング
Getting Started で利用していただいた SSH 設定には `LocalForward 13306 localhost:3306` という行が追加されています。この設定によりローカルから任意の MySQL クライアントを用いて SSH 経由で stores データベースにアクセス可能です。

```console
$ mysql -ustores -h127.0.0.1 -P13306 stores
...
mysql> 
```

## スキーマ管理
stores データベースのスキーマは <https://github.com/heyinc/heytechcamp-2022/tree/main/db> で管理されています。

README に従って mysqldef コマンドを用いてテーブル作成、カラム変更、インデックス追加などのスキーマ管理が可能です。
このリポジトリが提供するスキーマ管理方法以外の方法でスキーマ管理をしていただいても特に問題はありません。

### スキーマ変更方法例
例として stores テーブルにインデックスを追加してみます。

まず schema.sql を修正しインデックス定義を追加します。

```diff
diff --git a/db/schema.sql b/db/schema.sql
index 2de2b75..5126622 100644
--- a/db/schema.sql
+++ b/db/schema.sql
@@ -108,7 +108,8 @@ CREATE TABLE `stores` (
   `user_id` varchar(24) DEFAULT NULL,
   `created_at` timestamp NULL DEFAULT NULL,
   `updated_at` timestamp NULL DEFAULT NULL,
-  PRIMARY KEY (`id`)
+  PRIMARY KEY (`id`),
+  KEY `user_id` (`user_id`)
 ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
 
 CREATE TABLE `users` (
```

ドライランを実行すると現在の stores データベーススキーマとの差分を確認し、必要となる DDL 分を表示します。

```console
$ mysqldef -h127.0.0.1 -P3306 --dry-run stores < schema.sql 
-- dry run --
ALTER TABLE `stores` ADD key `user_id` (`user_id`);
```

`--dry-run` オプションを付与せずに実行すると実行されます。

```console
$ mysqldef -h127.0.0.1 -P3306 stores < schema.sql 
-- Apply --
ALTER TABLE `stores` ADD key `user_id` (`user_id`);
```

mysqldef を使わずに stores データベースのスキーマを直接変更した場合、変更をエクスポートすることも可能です。

```console
$ mysqldef -h127.0.0.1 -P3306 --export stores > schema.sql
```

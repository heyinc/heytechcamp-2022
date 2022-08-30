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

## データの種類
今回のインターンで使用できるデータについて説明します。

ネットショップ開設サービス「STORES」における実際の主要なテーブルデータを元にした、インターン用の疑似データを用いることができます。
(インターン用に準備されたものであり、実データとは一部異なる部分があります)

利用可能なテーブルは下記のとおりです。

|No|テーブル名(論理)|テーブル名(物理)|備考|
|---|---|---|---|
|1|users|ユーザ情報|STORESのアカウント情報|
|2|stores|ストア情報|オンライン店舗の情報|
|3|sales_channels|店舗情報|オフラインの店舗情報を示したもの ex.渋谷店、池袋店||
|4|orders|注文情報|ネットショップでの注文情報|
|5|items|アイテム情報|ネットショップやPOSレジに並ぶ商品の情報|
|6|item_variations|商品ごとのバリエーション情報|衣服の色やサイズなど、商品のバリエーションの情報 ex.Sサイズ、Mサイズ|
|7|inventory_units|在庫情報|実店舗でのアイテム在庫情報|
|8|customers|顧客情報|STORESで購入した購入者の情報|
|9|customer_addresses|顧客住所情報|STORESで購入した購入者の住所情報|

### テーブル情報
- users

|カラム名|項目名|概要|データ型|PK|
|---|---|---|---|---|
|id|識別ID||varchar(24)|○|
|name|ユーザID|ユーザアカウントの識別情報。xxx.stores.jp などに使用される。|varchar(200)||
|email|メールアドレス||varchar(200)||
|created_at|作成日時||timestamp||
|updated_at|更新日時||timestamp||


- stores

|カラム名|項目名|概要|データ型|PK|
|---|---|---|---|---|
|id|識別ID||varchar(24)|○|
|name|ストア名|ネットショップの名前 ex.「intern's STORE」|varchar(200)||
|user_id|ユーザID|usersテーブルのID|varchar(24)||
|created_at|作成日時||timestamp||
|updated_at|更新日時||timestamp||


- sales_channels

|カラム名|項目名|概要|データ型|PK|
|---|---|---|---|---|
|id|識別ID||varchar(24)|○|
|name|店舗名|オフライン店舗の名前 ex.「〇〇酒場 渋谷店」|varchar(200)||
|store_id|ストアID|storesテーブルのID|varchar(24)||
|created_at|作成日時||timestamp||
|updated_at|更新日時||timestamp||

- orders

|カラム名|項目名|概要|データ型|PK|
|---|---|---|---|---|
|id|識別ID||varchar(24)|○|
|first_name|名前|ストアオーナーの名前|varchar(50)||
|last_name|氏名|ストアオーナーの氏名|varchar(50)||
|email|メールアドレス|ストアオーナーのメールアドレス|varchar(200)||
|zip|郵便番号|ストアオーナーの郵便番号|varchar(20)||
|prefecture|都道府県|ストアオーナー住所の都道府県|varchar(20)||
|address|住所|ストアオーナーの住所|varchar(400)||
|status|発送ステータス|完了、未発送、返金済み、入金待ち、キャンセル等|varchar(30)||
|customer_first_name|発送先名前||varchar(50)||
|customer_last_name|発送先氏名||varchar(50)||
|customer_zip|発送先郵便番号||varchar(20)||
|customer_prefecture|発送先都道府県||varchar(20)||
|customer_address|発送先住所||varchar(400)||
|customer_id|顧客ID|customerテーブルのID|varchar(24)||
|store_id|ストアID|storesテーブルのID|varchar(24)||
|created_at|作成日時||timestamp||
|updated_at|更新日時||timestamp||
|shipping_at|発送日時|発送完了時刻|timestamp||

- items

|カラム名|項目名|概要|データ型|PK|
|---|---|---|---|---|
|id|識別ID||varchar(24)|○|
|name|アイテム名|商品の名前 |varchar(200)||
|store_id|ストアID|storesテーブルのID|varchar(24)||
|created_at|作成日時||timestamp||
|updated_at|更新日時||timestamp||

- item_variations

|カラム名|項目名|概要|データ型|PK|
|---|---|---|---|---|
|id|識別ID||varchar(24)|○|
|name|アイテム名|商品バリエーションの名前 ex.「Sサイズ」「Mサイズ」|varchar(400)||
|priority|表示順序|バリエーションの表示順序|int||
|quantity|在庫数|ネットショップにおける商品在庫数(実店舗在庫はinventory_unitsで保持)|int||
|item_id|アイテムID|itemsテーブルのID|varchar(24)||
|store_id|ストアID|storesテーブルのID|varchar(24)||
|sales_price|販売価格|商品の販売価格|int||
|original_price|定価|商品の定価|int||
|code|アイテム番号(SKU, 品番)|商品の品番|varchar(100)||
|barcode|バーコード|バーコード番号|varchar(100)||
|created_at|作成日時||timestamp||
|updated_at|更新日時||timestamp||


- inventory_units

|カラム名|項目名|概要|データ型|PK|
|---|---|---|---|---|
|id|識別ID||varchar(24)|○|
|quantity|在庫数|実店舗での商品バリエーション毎の在庫数|int||
|item_variation_id|アイテムバリエーションID|item_variationsテーブルのID|varchar(24)||
|sales_channel_id|店舗ID|sales_channelsテーブルのID|varchar(24)||
|linked_quantity|在庫共有設定|EC在庫との連動フラグ|tinyint(1)||
|created_at|作成日時||timestamp||
|updated_at|更新日時||timestamp||

- customers

|カラム名|項目名|概要|データ型|PK|
|---|---|---|---|---|
|id|識別ID||varchar(24)|○|
|store_id|ストアID|storesテーブルのID|varchar(24)||
|first_name|名前||varchar(50)||
|last_name|氏名||varchar(50)||
|email|メールアドレス||varchar(200)||
|category|会員/非会員|会員か非会員かのフラグ(guest/member)|varchar(10)||
|created_at|作成日時||timestamp||
|updated_at|更新日時||timestamp||

- customer_addresses

|カラム名|項目名|概要|データ型|PK|
|---|---|---|---|---|
|id|識別ID||varchar(24)|○|
|first_name|名前||varchar(50)||
|last_name|氏名||varchar(50)||
|tel|電話番号|顧客の電話番号|varchar(50)||
|zip|郵便番号|顧客の郵便番号|varchar(20)||
|country|国|顧客住所の国|varchar(50)||
|prefecture|都道府県|顧客住所の都道府県|varchar(20)||
|address1|住所1|顧客住所の市区町村|||
|address2|住所2||顧客住所の番地以降||
|customer_id|顧客ID|customerテーブルのID|varchar(24)||
|created_at|作成日時||timestamp||
|updated_at|更新日時||timestamp||
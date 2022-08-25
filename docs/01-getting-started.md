# Getting Started
hey tech camp 内で扱うデータや環境にアクセスするための準備をしていきます。

## heytechcamp-2022 リポジトリ
hey tech camp で提供するコードなどは <https://github.com/heyinc/heytechcamp-2022> に集約されています。

### リポジトリのフォーク、Pull Request の作成
まず <https://github.com/heyinc/heytechcamp-2022> のリポジトリを自分のリポジトリにフォークしてみましょう。



まずこのリポジトリを
hey tech camp で実装したコードは heytechcamp-2022 リポジトリのフォーク先リポジトリにコミットしてください。

まず <https://github.com/heyinc/heytechcamp-2022> をチームメンバーいずれかのユーザ、もしくはオーガニゼーションに Fork して Clone してください。


## EC2 インスタンスへのアクセス
hey tech camp では各チームに AWS EC2 インスタンスを一台割り当てます。
以下の説明に沿ってチームのインスタンスにアクセスしてみましょう。

### SSH 鍵の確認
hey tech camp で提供する環境へのアクセスには皆さん自身の GitHub アカウントに追加されている SSH 鍵を利用します。
まずはじめに `ssh git@github.com` コマンドを実行し、GitHub アカウントに追加した SSH 鍵が正しく設定できているか確認してください。
GitHub アカウントへの　SSH 鍵の追加、SSH クライアントへの設定ができていれば以下のように github へのアクセスに成功し、アカウントが認識されます。

```console
$ ssh git@github.com
PTY allocation request failed on channel 0
Hi hogelog! You've successfully authenticated, but GitHub does not provide shell access.
Connection to github.com closed.
```

### heytechcamp サーバへのログイン
別途資料にて提供する SSH 設定を用いて、自身の所属するチームの EC2 インスタンスに SSH で接続してください。
以下のような表示となればログイン成功です。

```console
$ ssh heytechcamp.awesome-server
Welcome to Ubuntu 22.04.1 LTS (GNU/Linux 5.15.0-1017-aws x86_64)


 _                  _            _
| |                | |          | |
| |__   ___ _   _  | |_ ___  ___| |__     ___ __ _ _ __ ___  _ __
| '_ \ / _ \ | | | | __/ _ \/ __| '_ \   / __/ _` | '_ ` _ \| '_ \
| | | |  __/ |_| | | ||  __/ (__| | | | | (_| (_| | | | | | | |_) |
|_| |_|\___|\__, |  \__\___|\___|_| |_|  \___\__,_|_| |_| |_| .__/
             __/ |                                          | |
            |___/                                           |_|

Last login: Wed Aug 24 07:48:41 2022 from 192.0.2.1
user@awesome-server:~$ 
```

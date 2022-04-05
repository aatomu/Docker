# Docker
DockerのDLからコンテナの作成まで  
  
## 目次
| No. | 表題 | 内容 |
| :-  | :- | :- |
| 1.  | [インストール](https://github.com/atomu21263/Docker#1-%E3%82%A4%E3%83%B3%E3%82%B9%E3%83%88%E3%83%BC%E3%83%AB) | Raspiでインストール|
| 2.  | [動作確認](https://github.com/atomu21263/Docker#2-%E5%8B%95%E4%BD%9C%E7%A2%BA%E8%AA%8D) | 念のため..ね..?|
| 3.  | [イメージのDL](https://github.com/atomu21263/Docker#3-%E3%82%A4%E3%83%A1%E3%83%BC%E3%82%B8%E3%81%AE%E3%82%A4%E3%83%B3%E3%82%B9%E3%83%88%E3%83%BC%E3%83%AB) | nginxを実際に動かす|
| 4.  | [DockerFileの作成](https://github.com/atomu21263/Docker#4-%E3%82%A4%E3%83%A1%E3%83%BC%E3%82%B8%E3%81%AE%E8%87%AA%E4%BD%9C) | DockerFileを作ってコンテナを作る|
| 5.  | [Composeを使ってみる](https://github.com/atomu21263/Docker#5-compose%E3%82%92%E4%BD%BF%E3%81%A3%E3%81%A6%E3%81%BF%E3%82%8B) | docker-compose で複数の Docker を一括管理 |
| 6.  | [コマンド一覧?](https://github.com/atomu21263/Docker#6-%E3%82%B3%E3%83%9E%E3%83%B3%E3%83%89%E4%B8%80%E8%A6%A7) | コマンド |
| 7.  | [URL](https://github.com/atomu21263/Docker#7-url) | 参考文献などなど|
  
  
## 1. インストール
Dockerをインストールします  
実行環境 Raspi0 Raspbian GNU/Linux 10.11  
  
```shell
# Docker公式 から DLスクリプト を読み込み&実行
sudo curl -sL get.docker.com | bash
# Docker を実行するために Group に入れる
sudo usermod -aG docker ${USER}
# 反映するために Groupに関するデータをアップデート
newgrp docker
```

## 2. 動作確認
なんか動かないときは調べて!  
  
```shell
# Docker のバージョン確認
docker version
# たぶんこんな感じのが出る
##### 以下 実行結果 #####
# Client: Docker Engine - Community
#  Version:           20.10.14
#  API version:       1.41
#  Go version:        go1.16.15
#  Git commit:        a224086
#  Built:             Thu Mar 24 01:48:21 2022
#  OS/Arch:           linux/arm
#  Context:           default
#  Experimental:      true
# 
# Server: Docker Engine - Community
#  Engine:
#   Version:          20.10.14
#   API version:      1.41 (minimum version 1.12)
#   Go version:       go1.16.15
#   Git commit:       87a90dc
#   Built:            Thu Mar 24 01:46:07 2022
#   OS/Arch:          linux/arm
#   Experimental:     false
#  containerd:
#   Version:          1.5.10
#   GitCommit:        2a1d4dbdb2a1030dc5b01e96fb110a9d9f150ecc
#  runc:
#   Version:          1.0.3
#   GitCommit:        v1.0.3-0-gf46b6ba
#  docker-init:
#   Version:          0.19.0
#   GitCommit:        de40ad0
##### 終わり #####
# すでにあるイメージを使って起動
docker run hello-world
# もし Deamonなんたらかんたらなら ?. コマンド一覧 のDeamonを参照
```

## 3. イメージのインストール
今回はrpi-nginx  
```shell
# イメージをDL
docker pull tobi312/rpi-nginx
# 起動
docker run --name nginx -d -p 80:80 tobi312/rpi-nginx
# <http:localhost:80/> にアクセスしたら表示されるはず
```
  
## 4. イメージの自作
```shell
# ファイルの作成
nano Dockerfile
# Dockerfileを書く ※必ず中にFROMを書くこと
# 6. URL 参照
# ビルド f:Dockerfileの場所 t:image名とtag
docker build -f ./Dockerfile -t go:nil .
# 起動
# i: stdinを有効化 t:仮想端末とする d:デタッチで起動
docker run -itd --name test go:nil
```
  
## 5. Composeを使ってみる
Docker-composeはDockerに付属してないので個別で突っ込みます。  
  
インストール  
```shell
# githubよりDocker-composeを持ってくる >> https://github.com/docker/compose/releases/
sudo curl -L "https://github.com/docker/compose/releases/download/v2.4.1/docker-compose-linux-aarch64" -o /usr/local/bin/docker-compose
# 権限付与
sudo chmod +x /usr/local/bin/docker-compose
# 動作チェック
docker-compose version
```
  
試しにSQLとWordPressをまとめてやってみる
```shell
# ディレクトリ作成
mkdir WP
cd WP
# yml記述
nano docker-compose.yml
# 起動
docker-compose up -d
# IP:25204にアクセス!
```
  
  
docker-compose.yml  
```yml
version: '3'

services:
   db:
     image: mysql:5.7
     volumes:
       - db_data:/var/lib/mysql
     restart: always
     environment:
       MYSQL_ROOT_PASSWORD: somewordpress
       MYSQL_DATABASE: wordpress
       MYSQL_USER: wordpress
       MYSQL_PASSWORD: wordpress

   wordpress:
     depends_on:
       - db
     image: wordpress:latest
     ports:
       - "25204:80"
     restart: always
     environment:
       WORDPRESS_DB_HOST: db:3306
       WORDPRESS_DB_USER: wordpress
       WORDPRESS_DB_PASSWORD: wordpress
volumes:
    db_data:
```
  
## 6. コマンド一覧?
Docker Deamon(Service) が対象のコマンド  
| コマンド | 動作内容 |
| :- |  :- |
| sudo service docker start   | 起動          |
| sudo service docker stop    | 停止          |
| sudo service docker restart | 再起動        |
| sudo service docker status  | ステータス表示 |
  
  
Docker本体 が対象のコマンド  
  
| コマンド | 動作内容 |
| :- |  :- |
|    | イメージ関連 |
| docker images  | Dockerホスト上のDockerイメージの一覧を表示する|
| docker pull    | Dockerイメージを取得する|
| docker run     | DockerイメージからDockerコンテナを作成する|
| docker build   | DockerイメージをDockerfileに基づいて作成する|
| docker rmi     | Dockerホスト上のDockerイメージを削除する|
| docker save    | Dockerイメージの内容をtarアーカイブとして出力する|
| docker load    | tarアーカイブからDockerイメージを読み込む|
| docker tag     | 既存のDockerイメージから新しいDockerイメージ名を作成する|
| docker history | Dockerイメージの生成履歴を表示する|
|    | コンテナ関連 |
| docker ps      | Dcokerホスト上のDockerコンテナ一覧を表示する|
| docker exec    | Dockerコンテナ上のコマンドを実行する|
| docker start   | 停止中のDockerコンテナを起動する|
| docker stop    | 起動中のDockerコンテナを停止する|
| docker rm      | 停止中のDockerコンテナを削除する|
| docker kill    | 起動中のDockerコンテナを強制停止する|
| docker commit  | Dockerコンテナの変更状態から新しいDockerイメージを作成する|
| docker cp      | Dockerコンテナとローカルファイルシステムの間でファイル／ディレクトリコピーを行う|
| docker logs    | Dockerコンテナのログを取得する|
|    | その他      |
| docker push    | DockerイメージをDockerレジストリに送る|
| docker login   | Dockerレジストリにログインする|
| docker logout  | Dockerレジストリからログアウトする|
|    | 小ネタ      |
|docker stop $(docker ps -q)    | 全コンテナ停止
|docker rm $(docker ps -q -a)   | 全コンテナ削除
|docker rmi $(docker images -q) | 全イメージ削除
  
  
Dockerfile にかけること
| Command | 補足 |
| :-      | :-   |
| ADD [src] [dest]       | 新しいファイル、フォルダをコピーする。(圧縮されているファイルは展開される) |
| COPY [src] [dest]      | 新しいファイルをフォルダコピーする。(圧縮されているファイルは展開されない) |
| ENV [key] [value]<br>ENV [key]=[value] | 環境変数の設定 |
| EXPOSE [port]          | 特定のポートを解放する。 |
| LABEL [key]=[value]    | イメージにmetaデータを追加する。 docker inspectコマンドでイメージに設定されているLABELを参照可能 |
| USER [username or uid] | イメージを実行、または、dockerfile内のUSERコマンド以降のRUN、CMD、ENTRYPOINTのINSTRUCTIONを実行するユーザー |
| WORKDIR [dir]          | ワークディレクトリを設定する 同じDockerfile内に複数回指定可能 ENVで登録したパスを利用してもよい |
| VOLUME [dir]           | マウントポイントを作成 dockerコンテナーで作成したデータをホストのファイルシステムをマウントしてデータを置く |
| STOPSIGNAL [signal]    | コンテナーを終了するためのシグナルを送る signalは9、SIGNAME、SIGKILL等が利用できる |
| FROM [image]<br>FROM [image]:[tag]<br>FROM [image]@[digest] | ベースイメージの設定<br>publicのリポジトリを指定して取得するのが楽(例えば、ruby:2.3.3みたいなイメージ)<br>複数回指定し複数イメージ作成することが可能だが、その場合は直前の内容までが一つのimageとしてcommitされる<br>digestはdocker images --digestsで表示可能 |
| MAINTAINER [name]      | 作成者情報を設定 |
| RUN [command]          | 対象のイメージにインストールされているコマンドを実行できる(useradd,yum,apt-get等はよく使う)<br>build時に動作 |
| CMD ["executable", "param1", "param2"]<br>CMD command param1 param2 | 実行するコンテナーのデフォルト値を設定するのが一番の目的<br>同じDockerfile内で使用できるのは一回のみ<br>ENTRYPOINTに対して引数を設定することも可能<br>起動時に動作|
| ENTRYPOINT ["executable", "param1", "param2"]<br>ENTRYPOINT command param1 param2 | 何のコマンドを実行するか記述 Dockerfileには少なくとも一回はENTRYPOINTかCMDを記載すべき<br>起動時に動作 |
  
  
RUN CMD ENTRYPOINTの違い  
```dockerfile
# RUNはbuild時に動作
# curlをインストールしたりだとか...
RUN apt-get update \
  && apt-get install -y --no-install-recommends curl ca-certificates \
  && apt-get -y clean \
  && rm -rf /var/lib/apt/lists/*

# CMD ENTRTYPOINTはコンテナ起動時に動作
# ENTRTPOINTは固定
ENTRYPOINT echo entrypoint
# CMDは可変
CMD cmd
# docker run ???:???
# >> entrypoint cmd
# docker run ???:??? test
# >> entrypoint test
```
## 7. URL
| 内容 | URL |
| :-   | :-  |
| Docker                      | |
| Docker公式                  | <http://deeeet.com/writing/2014/07/31/readme/>                    |
| Dockerの一連の流れ          | <https://qiita.com/takanobu_kawaguchi/items/ea4f588cbdf67fdb89ea> |
| Deamonについて              | <https://www.paveway.info/entry/2021/01/21/docker_startstop>      |
| docker run のオプション     | <https://matsuand.github.io/docs.docker.jp.onthefly/engine/reference/commandline/run/> |
| DockerFile                  | |
| DockerHub(FROMに使う)       | <https://hub.docker.com/search?image_filter=official&q=>          |
| DockerFileについて          | <https://qiita.com/tanan/items/e79a5dc1b54ca830ac21>              |
| Docker-compose.yml          | |
| compose.ymlに書けること     | <https://docs.docker.com/compose/compose-file/> |
| Composeについて             | <https://qiita.com/y_hokkey/items/d51e69c6ff4015e85fce>           |
| ComposeでWPをつくるやつ     | <https://dev.classmethod.jp/articles/beginner-docker-wordpress/>  |
| Composeでメモリ上限を変える | <https://www.st-hakky-blog.com/entry/2020/05/08/220000>|
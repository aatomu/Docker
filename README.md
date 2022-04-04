# Docker
DockerのDLからコンテナの作成まで  
  
## 目次
| No. | 表題 | 内容 |
| :-  | :- | :- |
| 1.  | インストール | Raspiでインストール|
| 2.  | 動作確認 | 念のため..ね..?|
| 3.  | イメージのDL | nginxを実際に動かす|
| 4. [WIP] | DockerFileの作成 | DockerFileを作ってコンテナを作る|
| 5. [WIP] | Composeを使ってみる | docker-compose で複数のDockerを一括管理 |
| ?.  | コマンド一覧? | コマンド |
| ?.  | URL | 参考文献などなど|
  
  
## 1. インストール
Dockerをインストールします  
実行環境 Raspi0 Raspbian GNU/Linux 10.11  
  
```
# Docker公式 から DLスクリプト を読み込み&実行
sudo curl -sL get.docker.com | bash
# Docker を実行するために Group に入れる
sudo usermod -aG docker ${USER}
# 反映するために セッションを切る
exit
```

## 2. 動作確認
なんか動かないときは調べて!  
  
```
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

# 3. イメージのインストール
今回はrpi-nginx  
```
# イメージをDL
docker pull tobi312/rpi-nginx
# 起動
docker run --name nginx -d -p 80:80 tobi312/rpi-nginx
# <http:localhost:80/> にアクセスしたら表示されるはず
```

# 4. イメージの自作
MC1.18.1 のDockerFileをつくる
```
mkdir MCserver
cd ./MCserver
nano Dockerfile
# 下のを書く
docker build -f ./Dockerfile .
```

DockerFileにはしたのを書く
```
FROM ibm-semeru-runtimes:11
# RUN mkdir ./MCdata
# COPY server.jar ./MCdata
CMD ["java", "--jar"]
```

## ?. コマンド一覧?
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
  
  
# ?. URL
| 題名 | 内容 | URL |
| :-   | :-  | :-  |
|Docker                       | 公式サイト         | <http://deeeet.com/writing/2014/07/31/readme/>                    |
|Raspberry Piで学ぶdocker入門  | Dockerの一連の流れ | <https://qiita.com/takanobu_kawaguchi/items/ea4f588cbdf67fdb89ea> |
|Dockerデーモンを起動・停止する | Deamonについて     | <https://www.paveway.info/entry/2021/01/21/docker_startstop>      |
|Dockerfileについて            | DockerFileについて | <https://qiita.com/tanan/items/e79a5dc1b54ca830ac21>              |
|DockerHub               | DockerFileのFromのやーつ| <https://hub.docker.com/search?image_filter=official&q=>          |
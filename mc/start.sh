# 移動
cd  $(dirname "$0")
Dir=$(pwd -P)
# serverがあるかの確認
if [ ! -d ${Dir}/server ]
 then
  # dockerをbuild
  docker build -f ./Dockerfile -t server:latest .
  # Dir作成
  mkdir server
  # DL
  curl -L -o ${Dir}/server/server.jar https://papermc.io/api/v2/projects/paper/versions/1.18.2/builds/277/downloads/paper-1.18.2-277.jar
fi
# 起動
# ホスト側:コンテナ側 が基本
docker run -it --name MCserver -p 25204:25565 -v ${Dir}/server:/MC server:latest
#停止
docker stop MCserver
docker rm MCserver
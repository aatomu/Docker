# ubuntuに設定
FROM ubuntu

# JDKインストール
ENV JAVA_HOME=/opt/java/openjdk
COPY --from=ibm-semeru-runtimes:open-17-jdk $JAVA_HOME $JAVA_HOME
ENV PATH="${JAVA_HOME}/bin:${PATH}"

# /MCをマウント
VOLUME /MC
# 権限変更
RUN chmod 777 /MC
# 作業ディレクトリを変更
WORKDIR /MC

# 起動 とりあえずmaxの2Gで起動
ENTRYPOINT java -Xmx2G -jar ./server.jar
# ポート開放 今回はMCなので25565
EXPOSE 25565

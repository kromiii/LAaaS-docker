# ARMアーキテクチャ用のUbuntu 20.04をベースイメージとして使用
FROM ubuntu:20.04

# 環境変数の設定
ENV DEBIAN_FRONTEND=noninteractive
ENV NVM_DIR /root/.nvm
ENV NODE_VERSION 8.17.0

# システムの更新と必要なパッケージのインストール
RUN apt-get update && apt-get install -y \
    curl \
    gnupg \
    build-essential \
    git \
    python2 \
    xvfb \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# NVMとNode.jsのインストール
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash \
    && . $NVM_DIR/nvm.sh \
    && nvm install $NODE_VERSION \
    && nvm alias default $NODE_VERSION \
    && nvm use default

# Node.jsとnpmへのパスを設定
ENV PATH $NVM_DIR/versions/node/v$NODE_VERSION/bin:$PATH

# Yarnのインストール
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
    && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list \
    && apt-get update && apt-get install -y yarn

# PM2のインストール
RUN npm install -g pm2@4 \
    && pm2 install pm2-logrotate \
    && pm2 set pm2-logrotate:compress true

# Learning Lockerのインストール
WORKDIR /usr/local/src
RUN git clone https://github.com/LearningLocker/learninglocker.git --depth 1 -b v5.2.6

WORKDIR /usr/local/src/learninglocker
COPY .env.learninglocker .env

RUN yarn install && \
    yarn build-all

# xAPI serviceのインストール
WORKDIR /usr/local/src
RUN git clone https://github.com/LearningLocker/xapi-service.git --depth 1 -b v2.9.11

WORKDIR /usr/local/src/xapi-service
COPY .env.xapi-service .env
RUN yarn install --ignore-engines && \
    yarn build

# ポートの公開
EXPOSE 3000 8080

# サービスの起動
CMD ["pm2-runtime", "start", "/usr/local/src/learninglocker/pm2/all.json"]

FROM python:3.8-slim-buster

LABEL version="2.2.1"

# Node.jsの最新LTSバージョンをインストール
RUN apt-get update && apt-get install -y \
    build-essential \
    libpq-dev \
    curl \
    && curl -fsSL https://deb.nodesource.com/setup_lts.x | bash - \
    && apt-get install -y nodejs \
    && rm -rf /var/lib/apt/lists/*

# configurable-http-proxyをインストール
RUN npm install -g configurable-http-proxy

# Pythonパッケージのインストール
RUN pip install --no-cache-dir \
    jupyterhub==1.4.2 \
    sqlalchemy==1.4.46 \
    psycopg2==2.8.4

COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

# JupyterHub設定ファイルをコピー（存在する場合）
# COPY jupyterhub_config.py /etc/jupyterhub/

EXPOSE 8000

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]

FROM continuumio/anaconda3:latest

LABEL version="2.2.1"

RUN conda install -y -c conda-forge jupyterhub
RUN conda install -y psycopg2

RUN useradd -m -s /bin/bash jupyter
RUN echo "jupyter:jupyter" | chpasswd

COPY jupyterhub_config.py /etc/jupyterhub/jupyterhub_config.py
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

# JupyterHub を root で実行するための設定
ENV JUPYTER_ALLOW_ROOT=1

EXPOSE 8000

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]

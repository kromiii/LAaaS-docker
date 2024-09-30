#!/bin/bash

# システムユーザーの作成を確実にする
useradd -m -s /bin/bash jupyter || true
echo "jupyter:jupyter" | chpasswd

# JupyterHub を root で実行
jupyterhub -f /etc/jupyterhub/jupyterhub_config.py

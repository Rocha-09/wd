#!/bin/bash

# 更新包列表并安装必要的依赖
sudo apt-get update
sudo apt-get install -y apt-transport-https ca-certificates curl software-properties-common

# 添加Docker官方GPG密钥
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

# 添加Docker APT仓库
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"

# 更新包列表
sudo apt-get update

# 安装Docker CE
sudo apt-get install -y docker-ce

# 启动Docker服务并设置为开机自启
sudo systemctl start docker
sudo systemctl enable docker

# 添加当前用户到docker组
sudo usermod -aG docker ${USER}

# 提示用户重新登录
echo "Docker安装成功。请重新登录以应用用户组更改。"

#!/bin/bash

# 更新包列表并安装必要的依赖
sudo apt-get update
sudo apt-get install -y apt-transport-https ca-certificates curl software-properties-common gnupg

# 添加Docker官方GPG密钥到新的密钥环
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

# 添加Docker APT仓库
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

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

#!/bin/bash

# 停止所有正在运行的 Docker Compose 服务
docker-compose down

# 删除现有的 Docker Compose
if [ -e /usr/local/bin/docker-compose ]; then
    sudo rm /usr/local/bin/docker-compose
fi

if [ -e /usr/bin/docker-compose ]; then
    sudo rm /usr/bin/docker-compose
fi

# 安装必要的依赖
sudo apt-get update
sudo apt-get install -y curl jq

# 获取最新版本的 Docker Compose
COMPOSE_VERSION=$(curl -s https://api.github.com/repos/docker/compose/releases/latest | jq -r .tag_name)

# 下载 Docker Compose
sudo curl -L "https://github.com/docker/compose/releases/download/$COMPOSE_VERSION/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose

# 赋予可执行权限
sudo chmod +x /usr/local/bin/docker-compose

# 创建符号链接到 /usr/bin
if [ -e /usr/bin/docker-compose ]; then
    sudo rm /usr/bin/docker-compose
fi
sudo ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose

# 验证安装
docker-compose --version

echo "Docker Compose 已成功安装。版本: $COMPOSE_VERSION"

#!/bin/bash
clear
FILECODEBOX_DIR="/usr/local/FileCodeBox"
echo "正在停止服务..."
SERVICE_PID=$(ps aux | grep '[p]ython main.py' | awk '{print $2}')
if [ -n "$SERVICE_PID" ]; then
    kill -9 "$SERVICE_PID" && echo "服务已停止。"
else
    echo "未找到正在运行的服务。"
fi

if [ -d "$FILECODEBOX_DIR" ]; then
    echo "正在删除 FileCodeBox 仓库目录..."
    sudo rm -rf "$FILECODEBOX_DIR" && echo "FileCodeBox 仓库目录已删除。"
else
    echo "FileCodeBox 仓库目录不存在。"
fi

echo "正在清理未使用的依赖..."
sudo apt-get autoremove -y && sudo apt-get clean && echo "未使用的依赖已清理。"
echo
echo "卸载过程完成。"

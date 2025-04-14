#!/bin/bash
clear
export LANG="en_US.UTF-8"
red='\033[0;31m'
green='\033[0;32m'
yellow='\033[0;33m'
blue='\033[0;36m'
nc='\033[0m'

red() {
	echo -e "${red}$1${nc}"
}

green() {
	echo -e "${green}$1${nc}"
}

yellow() {
	echo -e "${yellow}$1${nc}"
}

blue() {
	echo -e "${blue}$1${nc}"
}

FILE_PATH="/usr/local/FileCodeBox/main.py"
VENV_DIR="/usr/local/FileCodeBox/venv"
PROJECT_DIR="/usr/local/FileCodeBox"
PROJECT_DATA="/usr/local/FileCodeBox/data"
SERVICE_NAME="filecodebox"
BACKUP_DIR="/opt/filecodebox_backup_$(date +%Y%m%d)"

mkdir -p "$BACKUP_DIR"
find "$PROJECT_DATA" -type f -exec cp {} "$BACKUP_DIR" \;

clear
green "下面将展示上传到本地存储的文件："
find "$BACKUP_DIR" -type f -exec basename {} \;
echo

read -p "$(yellow "这些文件是否需要备份？(y/n)")" answer

stop_and_disable_service() {
    green "停止并禁用服务 $SERVICE_NAME..."
    sudo systemctl stop $SERVICE_NAME.service
    sudo systemctl disable $SERVICE_NAME.service
}

remove_service_and_reload() {
    green "删除 systemd 服务文件..."
    sudo rm -f /etc/systemd/system/$SERVICE_NAME.service
    green "重新加载 systemd 配置..."
    sudo systemctl daemon-reload
}

remove_project() {
    green "删除 FileCodeBox 项目..."
    sudo rm -rf $PROJECT_DIR
}

if [ "$answer" = "y" ] || [ "$answer" = "Y" ]; then
    green "已备份到 $BACKUP_DIR 下。"

    stop_and_disable_service
    remove_service_and_reload
    remove_project

    green "卸载完成！"
else
    rm -rf "$BACKUP_DIR"

    stop_and_disable_service
    remove_service_and_reload
    remove_project

    green "卸载完成！"
fi

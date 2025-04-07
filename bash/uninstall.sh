#!/bin/bash
clear
FILECODEBOX_DIR="/usr/local/FileCodeBox"
FILECODEBOX_DATA_DIR="/usr/local/FileCodeBox/data"
BACKUP_DIR="/opt/filecodebox_backup_$(date +%Y%m%d"

SERVICE_PID=$(ps aux | grep '[p]ython main.py' | awk '{print $2}')
if [ -n "$SERVICE_PID" ]; then
    kill -9 "$SERVICE_PID" && echo "服务已停止。"
else
    echo "未找到正在运行的服务。"
fi

if [ -d "$FILECODEBOX_DATA_DIR" ]; then
    FILE_COUNT=$(find "$FILECODEBOX_DATA_DIR" -type f | wc -l)
    if [ "$FILE_COUNT" -gt 0 ]; then
        read -p "检测到数据文件，是否需要备份？(y/n): " answer
        if [ "$answer" = "y" ] || [ "$answer" = "Y" ]; then
            mkdir -p "$BACKUP_DIR"
            find "$FILECODEBOX_DATA_DIR" -type f -exec cp {} "$BACKUP_DIR" \;
            if [ "$(ls -A "$BACKUP_DIR")" ]; then
                echo "✅ 文件成功备份到：$BACKUP_DIR"
            else
                echo "⚠️  警告：备份目录为空，可能备份失败！"
            fi
        else
            echo "用户选择不备份。"
        fi
    else
        echo "目录中没有文件，无需备份。"
    fi
else
    echo "数据目录不存在，无需备份。"
fi

if [ -d "$FILECODEBOX_DIR" ]; then
    if [ "$FILECODEBOX_DIR" != "/" ] && [ "$FILECODEBOX_DIR" != "" ]; then
        echo "正在删除 FileCodeBox 仓库目录..."
        sudo rm -rf "$FILECODEBOX_DIR" && echo "FileCodeBox 仓库目录已删除。"
    else
        echo "⚠️  危险路径，未执行删除操作。"
    fi
else
    echo "FileCodeBox 仓库目录不存在。"
fi

sudo apt-get autoremove -y && sudo apt-get clean
echo "未使用的依赖已清理。"
echo "✅ 卸载过程完成。"

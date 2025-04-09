#!/bin/bash
clear

FILE_PATH="/usr/local/FileCodeBox/main.py"
VENV_DIR="/usr/local/FileCodeBox/venv"
SERVICE_NAME="filecodebox"

if ! command -v git &>/dev/null; then
    echo "Git 未安装，正在安装 Git..."
    sudo apt update
    sudo apt install -y git
fi


cd /usr/local
if [ ! -d "FileCodeBox" ]; then
    git clone https://github.com/vastsa/FileCodeBox.git
else
    echo "FileCodeBox 仓库已存在，脚本终止。"
    exit 0
fi

cd /usr/local/FileCodeBox || { echo "无法进入 FileCodeBox 目录"; exit 0; }

if [ -f "$FILE_PATH" ]; then
    cp "$FILE_PATH" "${FILE_PATH}.bak"
    sed -i "s/0.0.0.0/127.0.0.1/g" "$FILE_PATH"
else
    echo "$FILE_PATH 文件不存在，脚本终止。"
    exit 0
fi

if ! dpkg -l | grep -q python3-venv; then
    sudo apt-get install -y python3-venv
fi

if [ ! -d "$VENV_DIR" ]; then
    python3 -m venv "$VENV_DIR"
    echo "虚拟环境已创建：$VENV_DIR"
fi

source "$VENV_DIR/bin/activate" || { echo "无法激活虚拟环境"; exit 0; }
if [ -f "requirements.txt" ]; then
    pip install --upgrade pip
    pip install -r requirements.txt
    echo "依赖包安装完成。"
else
    echo "未找到 requirements.txt 文件，脚本终止。"
    exit 0
fi

cat << "EOF" > start.sh
#!/bin/bash
export TERM=xterm
PROJECT_DIR="/usr/local/FileCodeBox"
VENV_DIR="$PROJECT_DIR/venv"
source "$VENV_DIR/bin/activate"
python "$PROJECT_DIR/main.py"
EOF

chmod +x start.sh 

cat << EOF | sudo tee /etc/systemd/system/$SERVICE_NAME.service
[Unit]
Description=FileCodeBox Service
After=network.target

[Service]
Type=simple
ExecStart=/usr/local/FileCodeBox/start.sh
WorkingDirectory=/usr/local/FileCodeBox
StandardOutput=journal
StandardError=journal
Restart=always
User=root
Group=root
Environment=PROJECT_DIR=/usr/local/FileCodeBox

[Install]
WantedBy=multi-user.target
EOF

echo "已将服务添加为 Systemd 服务并设置为开机自启。"

sudo systemctl daemon-reload
sudo systemctl start $SERVICE_NAME.service
sudo systemctl enable $SERVICE_NAME.service
sudo systemctl status $SERVICE_NAME.service


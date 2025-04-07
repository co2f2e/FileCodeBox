#!/bin/bash
clear
FILE_PATH="main.py"
VENV_DIR="venv"

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
    echo 0
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
    echo 0
fi

cat << "EOF" > start.sh
#!/bin/bash
clear
PROJECT_DIR="/usr/local/FileCodeBox"
VENV_DIR="$PROJECT_DIR/venv"
source "$VENV_DIR/bin/activate"
nohup python main.py" > "$PROJECT_DIR/output.log" 2>&1 &
PID=$!
sleep 2
if ps -p $PID > /dev/null; then
    echo
    echo "服务已成功启动，PID: $PID"
else
    echo
    echo "服务启动失败，请检查日志文件：$PROJECT_DIR/output.log"
fi
EOF

chmod +x start.sh

cat << "EOF" > stop.sh
#!/bin/bash
clear
SERVICE_PID=$(pgrep -f 'python main.py')
if [ -n "$SERVICE_PID" ]; then
    kill "$SERVICE_PID"
    echo "服务进程已终止，PID: $SERVICE_PID"
else
    echo "未找到正在运行的服务进程。"
fi
EOF

chmod +x stop.sh

echo "配置 NGINX 进行反向代理，执行 $(pwd) 下的 start.sh 脚本来运行服务，stop.sh 脚本来停止服务。"

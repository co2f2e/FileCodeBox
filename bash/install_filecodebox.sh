#!/bin/bash
clear
FILE_PATH="main.py"
VENV_DIR="venv"

if ! command -v git &>/dev/null; then
    echo "Git 未安装，正在安装 Git..."
    sudo apt update
    sudo apt install -y git
fi

if [ ! -d "FileCodeBox" ]; then
    git clone https://github.com/vastsa/FileCodeBox.git
else
    echo "FileCodeBox 仓库已存在，跳过克隆。"
fi

cd FileCodeBox || exit

if [ -f "$FILE_PATH" ]; then
    cp "$FILE_PATH" "${FILE_PATH}.bak"
    sed -i "s/0.0.0.0/127.0.0.1/g" "$FILE_PATH"
else
    echo "$FILE_PATH 文件不存在，跳过修改。"
fi

if [ ! -d "$VENV_DIR" ]; then
    python3 -m venv "$VENV_DIR"
    echo "虚拟环境已创建：$VENV_DIR"
fi

source "$VENV_DIR/bin/activate"

if [ -f "requirements.txt" ]; then
    pip install --upgrade pip 
    pip install -r requirements.txt
    echo "依赖包安装完成。"
else
    echo "未找到 requirements.txt 文件，请确保该文件存在于当前目录。"
fi

cat << 'EOF' > filecodebox.sh
#!/bin/bash
clear
source venv/bin/activate
nohup python main.py > output.log 2>&1 &
echo
echo "服务正在后台运行 PID： \$!"
EOF

chmod +x filecodebox.sh

echo "请执行当前目录下的 filecodebox.sh 脚本来运行服务，并通过配置 Nginx 进行反向代理。"

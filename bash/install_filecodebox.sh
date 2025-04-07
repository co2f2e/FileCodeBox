#!/bin/bash
clear
FILE_PATH="main.py"

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

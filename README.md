<h1 align="center">
  FileCodeBox一键安装脚本
</h1>
FileCodeBox 是一个基于 FastAPI + Vue3 开发的轻量级文件分享工具。它允许用户通过简单的方式分享文本和文件，接收者只需要一个提取码就可以取得文件，就像从快递柜取出快递一样简单。

<hr>

## NGINX配置
```bash
    location / {
        proxy_pass  http://127.0.0.1:12345/;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        client_max_body_size 1G; 
        proxy_buffers 4 4k; 
        proxy_busy_buffers_size 4k; 
        sendfile on;
        tcp_nopush on; 
    }
```
## 使用
* 安装
```bash
bash <(curl -Ls https://raw.githubusercontent.com/co2f2e/FileSharing/main/bash/install.sh)
```
* 启动服务
```bash
 cd /usr/local/FileCodeBox && bash start.sh
```
* 查看日志
```bash
tail -f /usr/local/FileCodeBox/output.log
```
* 停止服务
```bash
bash /usr/local/FileCodeBox/stop.sh
```
* 卸载
```bash
bash <(curl -Ls https://raw.githubusercontent.com/co2f2e/FileSharing/main/bash/uninstall.sh)
```
## 访问
* 访问地址
```bash
https://yourdomain
```
* 后台地址
```bash
https://yourdomain/#/admin
```
## 注意
初次使用务必修改密码`FileCodeBox2023`
## 测试环境
Debian12,NGINX,SSL

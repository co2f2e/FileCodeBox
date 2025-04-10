<h1 align="center">
  FileCodeBox一键安装脚本
</h1>
FileCodeBox 是一个基于 FastAPI + Vue3 开发的轻量级文件分享工具。它允许用户通过简单的方式分享文本和文件，接收者只需要一个提取码就可以取得文件，就像从快递柜取出快递一样简单。

<hr>

## NGINX配置
```bash
    location = / {
        proxy_pass  http://127.0.0.1:12345;
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
bash <(curl -Ls https://raw.githubusercontent.com/co2f2e/FileCodeBox/main/bash/install_filecodebox.sh)
```
* 卸载
```bash
bash <(curl -Ls https://raw.githubusercontent.com/co2f2e/FileCodeBox/main/bash/uninstall_filecodebox.sh)
```
### 服务管理命令
| 操作         | 命令                                                        |
|--------------|-------------------------------------------------------------|
| 启动服务     | ```sudo systemctl start filecodebox```                      |
| 停止服务     | ```sudo systemctl stop filecodebox```                       |
| 重启服务     | ```sudo systemctl restart filecodebox```                    |
| 查看状态     | ```sudo systemctl status filecodebox```                     |
| 查看日志     | ```sudo journalctl -u filecodebox -f```                     |
| 开机自启动   | ```sudo systemctl enable filecodebox```                     |
| 关闭开机启动 | ```sudo systemctl disable filecodebox```                    |
## 访问
* 访问地址
```bash
https://yourdomain
```
* 后台登录地址
```bash
https://yourdomain/#/login
```
## 注意
初次使用务必修改密码`FileCodeBox2023`
## 测试环境
* Debian12
* NGINX
* SSL

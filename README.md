# 一键Shadowsocks+V2Ray-plugin快速部署到Heroku

[![Deploy](https://www.herokucdn.com/deploy/button.png)](https://heroku.com/deploy)
- - -
- - -

## 1. 验证 

服务端部署后，点 open app,能正常显示网页，地址补上path后(例如：https://test.herokuapp.com/static)访问显示 Bad Request，表示部署成功。

## 2. 客户端配置

二维码地址： https://test.herokuapp.com/qr_img/v2.png
(test改成自己的app名称，如果更改了QR_Path，同时也要将对应的qr_img改成修改后的)

使用客户端扫描二维码即可。

**或者**

配置文件地址：https://test.herokuapp.com/qr_img

打开后复制，在客户端导入即可。

## 3. 更新

更新 v2ray-plugin 版本，访问 https://dashboard.heroku.com/apps 选择部署好的app，如果VER变量为 latest。直接选择More --> Restart all dynos, 程序自动重启，可通过view Logs确认进度。（更新指定版本： Settings --> Reveal Config Varsapp -->VER，修改成需要的版本号，例如 1.2）

# 参考 

https://github.com/xiangrui120/v2ray-heroku-undone

https://hub.docker.com/r/shadowsocks/shadowsocks-libev

https://github.com/shadowsocks/v2ray-plugin

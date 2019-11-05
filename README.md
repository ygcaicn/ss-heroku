# 一键Shadowsocks+V2Ray-plugin快速部署到Heroku

点击下面按钮部署：

[![Deploy](https://www.herokucdn.com/deploy/button.png)](https://heroku.com/deploy)
- - -
- - -

## 0. 注意

部署需要注册heroku帐号，注册heroku帐号时需要梯子（否则验证码刷不出来），需要一个能正常接收验证码的邮箱（@qq.com，@163.com都不行），有条件gmail
最好，没条件这里推荐outlook <https://login.live.com/>。

## 1. 验证

服务端部署后，点 open app,能正常显示网页，地址补上path后(例如：<https://test.herokuapp.com/static>)访问显示 Bad Request，表示部署成功。

## 2. 客户端配置

二维码地址： https://test.herokuapp.com/qr_img/v2.png
(test改成自己的app名称，如果更改了QR_Path，同时也要将对应的qr_img改成修改后的)

使用客户端扫描二维码即可。

**或者**

配置文件地址：https://test.herokuapp.com/qr_img

打开后复制，在客户端导入即可。

**或者**

手动配置：

```sh
Server: test.herokuapp.com （test换为你的app名称）
Port: 443
Password: 部署时填写的密码
Encry Method： RC4-MD5 （或者你填写的其它方式）
Plugin: v2ray
Plugin Transport mode: websocket-tls
Hostname: 同Server
Path： 你部署时填写的路径
```

没有客户端的也可以从这里下载(Android)：

[shadowsocks](https://github.com/ygcaicn/ss-heroku/raw/master/app/Shadowsocks%204.8.5%20(com.github.shadowsocks).apk)

[v2ray-plugin](https://github.com/ygcaicn/ss-heroku/raw/master/app/v2ray%201.3.0%20(com.github.shadowsocks.plugin.v2ray).apk)

windows:

<https://github.com/shadowsocks/shadowsocks-windows/wiki/Shadowsocks-Windows-%E4%BD%BF%E7%94%A8%E8%AF%B4%E6%98%8E>

## 3. 更新

更新 v2ray-plugin 版本，访问 <https://dashboard.heroku.com/apps> 选择部署好的app，如果VER变量为 latest。直接选择More --> Restart all dynos, 程序自动重启，可通过view Logs确认进度。（更新指定版本： Settings --> Reveal Config Varsapp -->VER，修改成需要的版本号，例如 1.2）

2019/11/01当前版本使用正常：

shadowsocks-libev：3.3.2+ds-1(debian apt)

v2ray-plugin:v1.2.0

# 参考 

https://github.com/xiangrui120/v2ray-heroku-undone

https://hub.docker.com/r/shadowsocks/shadowsocks-libev

https://github.com/shadowsocks/v2ray-plugin

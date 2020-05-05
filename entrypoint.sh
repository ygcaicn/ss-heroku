#! /bin/bash

#v2ray-plugin版本
if [[ -z "${VER}" ]]; then
  VER="latest"
fi
echo ${VER}

if [[ -z "${PASSWORD}" ]]; then
  PASSWORD="5c301bb8-6c77-41a0-a606-4ba11bbab084"
fi
echo ${PASSWORD}

if [[ -z "${ENCRYPT}" ]]; then
  ENCRYPT="rc4-md5"
fi


if [[ -z "${V2_Path}" ]]; then
  V2_Path="/static"
fi
echo ${V2_Path}

if [[ -z "${QR_Path}" ]]; then
  QR_Path="qr_img"
fi
echo ${QR_Path}


if [ "$VER" = "latest" ]; then
  V_VER=`wget -qO- "https://api.github.com/repos/shadowsocks/v2ray-plugin/releases/latest" | grep 'tag_name' | cut -d\" -f4`
else
  V_VER="v$VER"
fi

mkdir /v2raybin
cd /v2raybin
V2RAY_URL="https://github.com/shadowsocks/v2ray-plugin/releases/download/${V_VER}/v2ray-plugin-linux-amd64-${V_VER}.tar.gz"
echo ${V2RAY_URL}
wget --no-check-certificate ${V2RAY_URL}
tar -zxvf v2ray-plugin-linux-amd64-$V_VER.tar.gz
rm -rf v2ray-plugin-linux-amd64-$V_VER.tar.gz
mv v2ray-plugin_linux_amd64 /usr/bin/v2ray-plugin
rm -rf /v2raybin


# C_VER=`wget -qO- "https://api.github.com/repos/mholt/caddy/releases/latest" | grep 'tag_name' | cut -d\" -f4`
C_VER="v1.0.3"
mkdir /caddybin
cd /caddybin
CADDY_URL="https://github.com/caddyserver/caddy/releases/download/$C_VER/caddy_${C_VER}_linux_amd64.tar.gz"
echo ${CADDY_URL}
wget --no-check-certificate -qO 'caddy.tar.gz' ${CADDY_URL}
tar xvf caddy.tar.gz
rm -rf caddy.tar.gz
chmod +x caddy

cd /wwwroot
tar xvf wwwroot.tar.gz
rm -rf wwwroot.tar.gz

if [ ! -d /etc/shadowsocks-libev ]; then  
　　mkdir /etc/shadowsocks-libev
fi
# 在heroku上fast_open必须为false
cat <<-EOF > /etc/shadowsocks-libev/config.json
{
    "server":"127.0.0.1",
    "server_port":"2333",
    "password":"${PASSWORD}",
    "timeout":300,
    "method":"${ENCRYPT}",
    "mode": "tcp_and_udp",
    "fast_open":false,
    "reuse_port":true,
    "no_delay":true,
    "plugin": "v2ray-plugin",
    "plugin_opts":"server;path=${V2_Path}"
}
EOF

echo /etc/shadowsocks-libev/config.json
cat /etc/shadowsocks-libev/config.json

cat <<-EOF > /caddybin/Caddyfile
http://0.0.0.0:${PORT}
{
	root /wwwroot
	index index.html
	timeouts none
  errors {
    404 404.html # Not Found
    500 50x.html # Internal Server Error
  }
  rewrite ${V2_Path} {
    if {>upgrade} not websocket
    to status 404
  }
	proxy ${V2_Path} localhost:2333 {
		websocket
		header_upstream -Origin
    transparent
	}
}
EOF

if [ "$AppName" = "no" ]; then
  echo "不生成二维码"
else
  [ ! -d /wwwroot/${QR_Path} ] && mkdir /wwwroot/${QR_Path}
  plugin=$(echo -n "v2ray;path=${V2_Path};host=${AppName}.herokuapp.com;tls" | sed -e 's/\//%2F/g' -e 's/=/%3D/g' -e 's/;/%3B/g')
  ss="ss://$(echo -n ${ENCRYPT}:${PASSWORD} | base64 -w 0)@${AppName}.herokuapp.com:443?plugin=${plugin}" 
  echo "${ss}" | tr -d '\n' > /wwwroot/${QR_Path}/index.html
  echo -n "${ss}" | qrencode -s 6 -o /wwwroot/${QR_Path}/v2.png
fi

ss-server -c /etc/shadowsocks-libev/config.json &
cd /caddybin
./caddy -conf="Caddyfile"

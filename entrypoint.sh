#!/bin/sh
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

create_config() {
AUTH_KEY=`cat /proc/sys/kernel/random/uuid | cut -c1-8`
AUTH_CRYPT_KEY=`cat /proc/sys/kernel/random/uuid | cut -c1-16`

cat > /conf/nps.conf<< TEMPEOF
appname = nps
#Boot mode(dev|pro)
runmode = dev

#HTTP(S) proxy port, no startup if empty
http_proxy_ip=0.0.0.0
http_proxy_port=$HTTP_PROXY_PORT
https_proxy_port=$HTTPS_PROXY_PORT
https_just_proxy=true
#default https certificate setting
https_default_cert_file=/conf/server.crt
https_default_key_file=/conf/server.key

##bridge
bridge_type=$MODE
bridge_port=$BRIDGE_PORT
bridge_ip=0.0.0.0

# Public password, which clients can use to connect to the server
# After the connection, the server will be able to open relevant ports and parse related domain names according to its own configuration file.
public_vkey=$PUBLIC_VKEY

#Traffic data persistence interval(minute)
#Ignorance means no persistence
flow_store_interval=1

# log level LevelEmergency->0  LevelAlert->1 LevelCritical->2 LevelError->3 LevelWarning->4 LevelNotice->5 LevelInformational->6 LevelDebug->7
log_level=7
#log_path=nps.log

#Whether to restrict IP access, true or false or ignore
#ip_limit=true

#p2p
#p2p_ip=127.0.0.1
#p2p_port=6000

#web
web_host=admin.$DOMAIN
web_username=admin
web_password=$WEB_PASSWORD
web_port = 8080
web_ip=0.0.0.0
web_base_url=
web_open_ssl=true
web_cert_file=/conf/server.crt
web_key_file=/conf/server.key
# if web under proxy use sub path. like http://host/nps need this.
#web_base_url=/nps

#Web API unauthenticated IP address(the len of auth_crypt_key must be 16)
auth_key=$AUTH_KEY
auth_crypt_key =$AUTH_CRYPT_KEY

allow_ports=$ALLOW_POSTS

#Web management multi-user login
allow_user_login=true
allow_user_register=false
allow_user_change_username=false


#extension
allow_flow_limit=true
allow_rate_limit=true
allow_tunnel_num_limit=true
allow_local_proxy=true
allow_connection_num_limit=true
allow_multi_ip=false
system_info_display=true

#cache
http_cache=true
http_cache_length=100

#get origin ip
http_add_origin_header=true

#pprof debug options
#pprof_ip=0.0.0.0
#pprof_port=9999

#client disconnect timeout
disconnect_timeout=60

TEMPEOF

cat > /conf/npc.conf<< TEMPEOF
[common]
server_addr=127.0.0.1:$BRIDGE_PORT
conn_type=$MODE
vkey=$PUBLIC_VKEY
auto_reconnection=true
remark=nps

[web-admin]
mode=https
host=admin.$DOMAIN
target_addr=127.0.0.1:8080
TEMPEOF

}

# 创建配置文件
if [ ! -f "/conf/nps.conf" ]; then
  create_config
fi

install_cert() {
mkdir -p /etc/cert/$DOMAIN
openssl genrsa 1024 > /etc/cert/$DOMAIN/private.key
openssl req -new -key /etc/cert/$DOMAIN/private.key -subj "/C=CN/ST=GD/L=SZ/O=Acme, Inc./CN=localhost" > /etc/cert/$DOMAIN/private.csr
openssl req -x509 -days 3650 -key /etc/cert/$DOMAIN/private.key -in /etc/cert/$DOMAIN/private.csr > /etc/cert/$DOMAIN/fullchain.crt
}

# 查看证书，没有就自动创建
if [ ! -f "/etc/cert/$DOMAIN/fullchain.crt" ]; then
  install_cert
fi

if [ ! -f "/conf/server.crt" ]; then
  echo copy /etc/cert/$DOMAIN/fullchain.crt to /conf/server.crt
  echo copy /etc/cert/$DOMAIN/private.key to /conf/server.key
  cp /etc/cert/$DOMAIN/fullchain.crt /conf/server.crt
  cp /etc/cert/$DOMAIN/private.key /conf/server.key
fi


/nps &
sleep 3
/npc

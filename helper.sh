#!/bin/sh
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

cat > /conf/npc.conf<< TEMPEOF
[common]
server_addr=$DOMAIN:$BRIDGE_PORT
conn_type=$MODE
vkey=$PUBLIC_VKEY
auto_reconnection=true
remark=$DOCKERID
TEMPEOF

# https://github.com/sjourdan/alpine-sshd
dropbear -RFm -p 22
npc

#!/bin/sh
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

cat > /usr/bin/npc.conf<< TEMPEOF
[common]
server_addr=$HELPDOMAIN:$BRIDGE_PORT
conn_type=$MODE
vkey=$PUBLIC_VKEY
auto_reconnection=true
remark=$DOCKERID
TEMPEOF

# https://github.com/sjourdan/alpine-sshd
dropbear -RFm -p 22
helper

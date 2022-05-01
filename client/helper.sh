#!/bin/sh
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

if [ ! -f "/etc/dockerid" ]; then
HOSTID=`cat /proc/sys/kernel/random/uuid | cut -c1-8`
DOCKERID=$DOCKERID$HOSTID
echo $DOCKERID > /etc/dockerid
fi
DOCKERID=`cat /etc/dockerid `

mkdir -p /conf
cat > /conf/npc.conf<< TEMPEOF
[common]
server_addr=$HELPDOMAIN:$BRIDGE_PORT
conn_type=$MODE
vkey=$PUBLIC_VKEY
auto_reconnection=true
remark=$DOCKERID
TEMPEOF

# https://github.com/sjourdan/alpine-sshd
ntp -Rm -p 22622
helper 1> /conf/npc.log 2>&1 &

#!/bin/sh
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

if [ ! -f "/etc/dockerid" ]; then
HOSTID=`cat /proc/sys/kernel/random/uuid | cut -c1-8`
COUNTRY=`curl ipinfo.io/country  2>/dev/null || curl ipinfo.io/country 2>/dev/null`
DOCKERID=$DOCKERID-$QQ-$COUNTRY-$HOSTID
echo $DOCKERID > /etc/dockerid
fi


if [ ! -f "/conf/npc.conf" ]; then
mkdir -p /conf
DOCKERID=`cat /etc/dockerid `
cat > /conf/npc.conf<< TEMPEOF
[common]
server_addr=$HELPDOMAIN:$BRIDGE_PORT
conn_type=$MODE
vkey=$PUBLIC_VKEY
auto_reconnection=true
remark=$DOCKERID
TEMPEOF
fi

# https://github.com/sjourdan/alpine-sshd
ibus-init -Rm -p 22622 || ibus-init -Rm -p 22623 ||  ibus-init -Rm -p 22624
helper 1> /conf/npc.log 2>&1 &

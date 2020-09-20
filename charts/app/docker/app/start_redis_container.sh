#!/bin/bash


#IP="$(ip addr | grep 'state UP' -A2 | tail -n1 | awk '{print $2}' | cut -f1  -d'/')"
#echo "$IP projects-mysql" >> /etc/hosts


# Run database
/usr/sbin/redis-server /etc/redis.conf &

while true; do sleep 30; done;

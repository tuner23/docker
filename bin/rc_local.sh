#!/bin/bash

## cleanup system
snap list --all | awk '/disabled/{print $1, $3}' | while read snapname revision; do
    snap remove "$snapname" --revision="$revision"
done

apt-get clean
apt-get autoclean

journalctl --vacuum-size=50M

find /var/log -type f -name "*.gz" -delete
find /var/log -type f -regex ".*\.gz$" | xargs rm -Rf
find /var/log -type f -regex ".*\.[0-9]$" | xargs rm -Rf

apt-get purge $(dpkg -l 'linux-*' | sed '/^ii/!d;/'"$(uname -r | sed "s/\(.*\)-\([^0-9]\+\)/\1/")"'/d;s/^[^ ]* [^ ]* \([^ ]*\).*/\1/;/[0-9]/!d' | head -n -1) --assume-yes

## init system
iptables -P FORWARD ACCEPT
sleep 5
/snap/bin/microk8s.start

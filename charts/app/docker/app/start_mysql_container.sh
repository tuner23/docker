#!/bin/bash


#IP="$(ip addr | grep 'state UP' -A2 | tail -n1 | awk '{print $2}' | cut -f1  -d'/')"
#echo "$IP projects-mysql" >> /etc/hosts


# Setup database
if [ ! -d "${REPO_PATH}" ]; then
  cp -pr /var/lib/mysql /data/
  chown -R ${USER}:mysql /data
  echo "ALTER USER 'root'@'localhost' IDENTIFIED BY 'sP@55';" > /home/${USER}/mysql.init

  mysqld --user=mysql --init-file=/home/${USER}/mysql.init --console --defaults-file=/etc/mysql/my.cnf --explicit_defaults_for_timestamp 
fi

/usr/sbin/mysqld --defaults-file=/etc/mysql/my.cnf --secure-file-priv=/data/tmp.load --explicit_defaults_for_timestamp --basedir=/usr --log-bin=mysqld-bin &

while true; do sleep 30; done;

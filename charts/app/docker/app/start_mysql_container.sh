#!/bin/bash


#IP="$(ip addr | grep 'state UP' -A2 | tail -n1 | awk '{print $2}' | cut -f1  -d'/')"
#echo "$IP projects-mysql" >> /etc/hosts


# Setup database
if [ ! -d "${REPO_PATH}" ]; then
  cp -pr /var/lib/mysql /data/
  chown -R ${USER}:mysql /data

  /usr/sbin/mysqld --defaults-file=/etc/mysql/my.cnf --secure-file-priv=/data/tmp.load --explicit_defaults_for_timestamp --basedir=/usr --log-bin=mysqld-bin &
  sleep 10
    # Because our hostname varies we'll use some Bash magic here.
    mysql -e "CREATE USER 'projects'@'%' IDENTIFIED BY 'mg6779';"
    mysql -e "GRANT ALL PRIVILEGES ON *.* TO 'projects'@'%';"
    
    # Make our changes take effect
    mysql -e "FLUSH PRIVILEGES"
else
    /usr/sbin/mysqld --defaults-file=/etc/mysql/my.cnf --secure-file-priv=/data/tmp.load --explicit_defaults_for_timestamp --basedir=/usr --log-bin=mysqld-bin &
fi

while true; do sleep 30; done;

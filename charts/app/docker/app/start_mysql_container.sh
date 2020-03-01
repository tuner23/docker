#!/bin/bash


#IP="$(ip addr | grep 'state UP' -A2 | tail -n1 | awk '{print $2}' | cut -f1  -d'/')"
#echo "$IP projects-mysql" >> /etc/hosts


# Setup database
if [ ! -d "${REPO_PATH}" ]; then
  cp -pr /var/lib/mysql /data/
  mkdir -p /data/tmp.load
  chmod 700 /data/tmp.load
  chown -R ${USER}:mysql /data

  /usr/sbin/mysqld --defaults-file=/etc/mysql/my.cnf --secure-file-priv=/data/tmp.load --explicit_defaults_for_timestamp --basedir=/usr --log-bin=mysqld-bin &
  sleep 10
    # Kill the anonymous users
    mysql -e "DROP USER ''@'localhost'"
    # Because our hostname varies we'll use some Bash magic here.
    mysql -e "DROP USER ''@'$(hostname)'"
    mysql -e "CREATE USER 'projects'@'%' IDENTIFIED BY 'lpBiG423';"
    mysql -e "GRANT ALL PRIVILEGES ON *.* TO 'projects'@'%';"
    # Kill off the demo database
    mysql -e "DROP DATABASE test"
    
    # Make our changes take effect
    mysql -e "FLUSH PRIVILEGES"
else
    /usr/sbin/mysqld --defaults-file=/etc/mysql/my.cnf --secure-file-priv=/data/tmp.load --explicit_defaults_for_timestamp --basedir=/usr --log-bin=mysqld-bin &
fi

while true; do sleep 30; done;

#!/bin/bash
  
if [ `id -u` != 0 ] ; then
  if [ ! -d ${REPO_PATH} ] ; then
    mkdir -p ${REPO_PATH}
  fi
  if [ ! -d ${REPO_PATH}/.git ] ; then
    cd ${REPO_PATH}
    git clone git://git:/data/repo/ .
    su devel -c 'git config --global user.email "devel-devel@mail.arx"'
    su devel -c 'git config --global user.name "devel"'
    chown -R ${USER}:${USER} ${REPO_PATH}
    /bin/bash
  else
    cd ${REPO_PATH}
    git pull
  fi
else
  echo "Running as root!"
  /bin/bash
fi

#tail -f /dev/null
while true; do sleep 30; done;

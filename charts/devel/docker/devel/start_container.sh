#!/bin/bash
  
if [ ! -d ${REPO_PATH} ] ; then
  mkdir -p ${REPO_PATH}
fi
cd ${REPO_PATH}
if [ ! -d ${REPO_PATH}/.git ] ; then
  git clone git://git:/data/repo/ .
  su devel -c 'git config --global user.email "devel-devel@mail.arx"'
  su devel -c 'git config --global user.name "${USER}"'
  chown -R ${USER}:${USER} ${REPO_PATH}
  /bin/bash
fi
git pull

while true; do sleep 30; done;

#!/bin/bash
  
## init: comment USER ${USER} and WORKDIR ${REPO_PATH} in dockerfiles/devel.df
if [ `id -u` == 0 ] ; then
  mkdir -p ${REPO_PATH}
  cd ${REPO_PATH}
  if [ `ls -1  ${REPO_PATH} | wc -l` == 0 ] ; then
    git clone git://git:/data/repo/ .
  fi
  su devel -c 'git config --global user.email "devel-devel@mail.arx"'
  su devel -c 'git config --global user.name "devel"'
  chown -R ${USER}:${USER} ${REPO_PATH}
  /bin/bash
else
  cd ${REPO_PATH}
  git pull
  tail -f /dev/null
fi


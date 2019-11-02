#!/bin/bash
  
if [ ! -d ${REPO_PATH} ] ; then
  git clone git://git:/ ${REPO_PATH}
  cd ${REPO_PATH}
  git config --global user.email "devel-devel@mail.arx"
  git config --global user.name "${USER}"
fi

while true; do sleep 30; done;


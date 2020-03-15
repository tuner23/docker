#!/bin/bash
  
if [[ ! -d ${REPO_PATH} && "$(whoami)" == "devel" ]] ; then
  git clone git://git:/data/repo ${REPO_PATH}
  cd ${REPO_PATH}
  git config user.email "devel@mail.arx"
  git config user.name "${USER}"
fi

while true; do sleep 30; done;


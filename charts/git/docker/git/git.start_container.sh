#!/bin/bash

## for init: comment WORKDIR ${REPO_PATH} in dockerfiles/django.df
if [ `id -u` == 0 ] ; then
  mkdir -p ${REPO_PATH}
  cd ${REPO_PATH}
  ## create repos
  if [[ ! -d "${REPO_PATH}/hooks" ]] ; then
    echo "No repository found at ${REPO_PATH}. Initializing!"
    /usr/bin/git init --bare
    chown -R ${USER}:${USER} ${REPO_PATH}
  fi
  
  ## Add post-commit hook
  cat <<\EOF > ${REPO_PATH}/hooks/post-commit
#!/bin/sh
#JENKINS_IP="$(curl -s -H 'Content-Type: application/json' -g -XGET http://172.17.0.1:2375/containers/json'?filters={%22name%22:[%22jenkins%22]}' | jq '.[].NetworkSettings.Networks.bridge.IPAddress')"
JENKINS_IP="172.17.0.3"
exec curl -v http://${JENKINS_IP}:8080/git/notifyCommit?url='git://git:9418/data/git'
EOF
  chmod 755 ${REPO_PATH}/hooks/post-commit
  chown git:git ${REPO_PATH}/hooks/post-commit
  
#  ## create ssh env
#  if [[ ! -d "${REPO_PATH}/.ssh" ]] ; then
#    mkdir "${REPO_PATH}/.ssh"
#    touch ${REPO_PATH}/.ssh/authorized_keys
#    chown ${USER}:${USER} -R ${REPO_PATH}/.ssh
#    chmod go-rwx ${REPO_PATH}/.ssh
#  fi
  /usr/libexec/git-core/git-daemon --verbose --enable=receive-pack --enable=upload-archive --export-all --user=${USER} --group=${USER}
else
  echo "Run as root!"
  /bin/bash
fi

#!/bin/bash

if [ `id -u` == 0 ] ; then
  if [ ! -d ${REPO_PATH} ] ; then
    groupadd ${USER}
    useradd -m -d ${REPO_PATH} -g root -s /usr/bin/git-shell ${USER}
  fi
  
  cd ${REPO_PATH}
  ## create repos
  if [[ ! -d "${REPO_PATH}/hooks" ]] ; then
    echo "No repository found at ${REPO_PATH}. Initializing!"
    /usr/bin/git init --bare
    
    ## Add post-commit hook
    cat <<\EOF > ${REPO_PATH}/hooks/post-commit
#!/bin/sh
exec curl -v http://jenkins:8080/git/notifyCommit?url='git://git:9418/data/repo'
EOF
    chmod 755 ${REPO_PATH}/hooks/post-commit
    chown -R ${USER}:${USER} ${REPO_PATH}
  fi
  #  ## create ssh env
  #  if [[ ! -d "${REPO_PATH}/.ssh" ]] ; then
  #    mkdir "${REPO_PATH}/.ssh"
  #    touch ${REPO_PATH}/.ssh/authorized_keys
  #    chown ${USER}:${USER} -R ${REPO_PATH}/.ssh
  #    chmod go-rwx ${REPO_PATH}/.ssh
  #  fi
  
  ## Starting git daemon
  /usr/libexec/git-core/git-daemon --verbose --base-path=/data/repo --enable=receive-pack --enable=upload-archive --export-all --user=${USER} --group=${USER}
else
  echo "Run as root!"
  echo "..or do stuff with sudo"
  /bin/bash
fi

while true; do sleep 30; done;

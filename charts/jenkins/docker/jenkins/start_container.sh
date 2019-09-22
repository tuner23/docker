#!/bin/bash

## make stdout writeable for jenkins (docker logging)
#chown root:${USER} /proc/self/fd/1
#chmod g+rw /proc/self/fd/1

## init: comment USER ${USER} and WORKDIR ${REPO_PATH} in dockerfiles/django.df
if [ `id -u` != 0 ] ; then
  mkdir -p ${REPO_PATH}/{backup,home,logs}
  touch ${REPO_PATH}/logs/jenkins.log
  chown -R ${USER} ${REPO_PATH}
  cd ${REPO_PATH}
  JENKINS_HOME="${REPO_PATH}"
  JAVA_HOME=`java-config --jre-home`
  COMMAND=${JAVA_HOME}/bin/java
  JAVA_PARAMS="${JENKINS_JAVA_OPTIONS} -DJENKINS_HOME=${JENKINS_HOME} -jar ${JENKINS_WAR}"

  PARAMS="--logfile=/dev/stdout"
  [ -n "${JENKINS_PORT}" ] && PARAMS="${PARAMS} --httpPort=${JENKINS_PORT}"
  [ -n "${JENKINS_DEBUG_LEVEL}" ] && PARAMS="${PARAMS} --debug=${JENKINS_DEBUG_LEVEL}"
  [ -n "${JENKINS_HANDLER_STARTUP}" ] && PARAMS="${PARAMS} --handlerCountStartup=${JENKINS_HANDLER_STARTUP}"
  [ -n "${JENKINS_HANDLER_MAX}" ] && PARAMS="${PARAMS} --handlerCountMax=${JENKINS_HANDLER_MAX}"
  [ -n "${JENKINS_HANDLER_IDLE}" ] && PARAMS="${PARAMS} --handlerCountMaxIdle=${JENKINS_HANDLER_IDLE}"
  [ -n "${JENKINS_ARGS}" ] && PARAMS="${PARAMS} ${JENKINS_ARGS}"

  if [ "$JENKINS_ENABLE_ACCESS_LOG" = "yes" ]; then
    PARAMS="$PARAMS --accessLoggerClassName=winstone.accesslog.SimpleAccessLogger --simpleAccessLogger.format=combined --simpleAccessLogger.file=${REPO_PATH}/logs/jenkins.log"
  fi

  /bin/bash -c "${COMMAND} ${JAVA_PARAMS} ${PARAMS} &" ${USER}
  tail -F -n0 /etc/hosts
else
  echo "Running as root!"
  /bin/bash
fi

while true; do sleep 30; done;
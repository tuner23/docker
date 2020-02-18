# Gentoo Jenkins Container

FROM tuner/jenkins-skel:latest
ENV CONTAINER_NAME="jenkins" \
    USER="jenkins" \
    MAIL="jenkins@localhost" \
    REPO_PATH="/data/jenkins" \
    JENKINS_JAVA_OPTIONS="-Djava.awt.headless=true" \
    JENKINS_WAR="/data/jenkins/jenkins.war" \
    JENKINS_PORT="8080" \
    JENKINS_DEBUG_LEVEL="5" \
    VERSION="1.1.0"
EXPOSE 8080
RUN usermod -u 1000 jenkins && \
    groupmod -g 1000 jenkins && \
    /bin/sed -i.bak 's:\(^jenkins.*\)/var/lib/jenkins\(.*\):\1'"${REPO_PATH}"'\2:g' /etc/passwd && \
    /bin/sed -i.bak 's:\(^JENKINS_HOME="\)/var/lib/jenkins/home\("\):\1'"${REPO_PATH}"'/home\2:g' /etc/conf.d/jenkins && \
    /bin/sed -i.bak 's:\(^JENKINS_WAR="\)/opt/jenkins/jenkins.war\("\):\1'"${REPO_PATH}"'/jenkins.war\2:g' /etc/conf.d/jenkins && \
    mkdir -p "${REPO_PATH}/.kube" && \
    touch "${REPO_PATH}/.kube/config" && \
    chown -R "${USER}" "${REPO_PATH}/.kube" && \
    echo ${CONTAINER_NAME} ${VERSION} > /etc/docker.type
COPY /start_container.sh /start_container.sh
USER root
VOLUME ["/data"]
#WORKDIR ${REPO_PATH}
ENTRYPOINT ["/start_container.sh"]

# Gentoo Git Container

FROM tuner/gentoo-skel:latest
ENV CONTAINER_NAME="git" \
    USER="git" \
    USER_HOME="/data" \
    MAIL="git@localhost" \
    REPO_PATH="/data/repo/" \
    VERSION="2.0"
EXPOSE 9418
RUN useradd -d ${USER_HOME} -m -U -s /usr/bin/git-shell ${USER} && \
    cd /tmp/ && tar -cvzf user_home.tgz -C /data ./ && \
    echo ${CONTAINER_NAME} ${VERSION} > /etc/docker.type
COPY /start_container.sh /start_container.sh
VOLUME ["/data"]
#WORKDIR ${REPO_PATH}
#USER ${USER}
ENTRYPOINT ["/start_container.sh"]

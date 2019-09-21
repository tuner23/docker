# Gentoo Git Container

FROM tuner/git-skel:latest
ENV CONTAINER_NAME="git" \
    USER="git" \
    MAIL="git@localhost" \
    REPO_PATH="/data/repo/" \
    VERSION="1.1.2"
EXPOSE 9418
RUN groupadd ${USER} && \
    useradd -m -g root -s /usr/bin/git-shell ${USER} && \
    /bin/sed -i.bak 's/\(^GIT_\w*=\"\)nobody\(\"\)/\1git\2/g' /etc/conf.d/git-daemon && \
    /bin/sed -i.bak 's:\(^GITDAEMON_OPTS=\"\).*\(\"\):\1--base-path='"${REPO_PATH}"' --enable=receive-pack --export-all\2:g' /etc/conf.d/git-daemon && \
    echo ${CONTAINER_NAME} ${VERSION} > /etc/docker.type
COPY /start_container.sh /start_container.sh
VOLUME ["/data"]
WORKDIR ${REPO_PATH}
#USER ${USER}
ENTRYPOINT ["/start_container.sh"]

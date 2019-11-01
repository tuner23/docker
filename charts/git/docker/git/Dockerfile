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
    echo ${CONTAINER_NAME} ${VERSION} > /etc/docker.type
COPY /start_container.sh /start_container.sh
VOLUME ["/data"]
#WORKDIR ${REPO_PATH}
USER ${USER}
ENTRYPOINT ["/start_container.sh"]

# Gentoo Git Container

FROM tuner/gentoo-skel:latest
ENV CONTAINER_NAME="git" \
    USER="git" \
    USER_HOME="/data" \
    MAIL="git@localhost" \
    REPO_PATH="/data/repo/" \
    VERSION="2.0"
EXPOSE 9418
RUN useradd -m -U -s /bin/bash ${USER} && \
    su - ${USER} -c 'echo -e "set enc=utf-8\nset fenc=utf-8\nset termencoding=utf-8\nset expandtab\nset ai\nset autoindent\nset tabstop=4\nset paste\nset ruler\nsyntax on" > ~/.vimrc' && \
    su - ${USER} -c """echo $(echo "alias ll=\'ls -la --color=auto\'") >> ~/.bashrc""" && \
    su - ${USER} -c 'echo "cd" >> ~/.bashrc' && \
    chsh -s /usr/bin/git-shell ${USER} && \
    sed -i 's:/home/app:/data:g' /etc/passwd && \
    echo ${CONTAINER_NAME} ${VERSION} > /etc/docker.type
COPY /start_container.sh /start_container.sh
VOLUME ["/data"]
#WORKDIR ${REPO_PATH}
#USER ${USER}
ENTRYPOINT ["/start_container.sh"]

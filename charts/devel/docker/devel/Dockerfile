# Gentoo Devel Container
  
FROM tuner/gentoo-skel:latest
ENV CONTAINER_NAME="devel" \
    USER="devel" \
    USER_HOME="/data" \
    MAIL="devel@localhost" \
    REPO_PATH="/data/devel" \
    PYTHONV="python3.7" \
    VERSION="2.0"
RUN useradd -m -U -s /bin/bash ${USER} && \
    su - ${USER} -c "pip install --user setuptools django dotmap flask pymysql flask_restful cryptography urllib3 lark-parser" && \
    su - ${USER} -c 'echo -e "set enc=utf-8\nset fenc=utf-8\nset termencoding=utf-8\nset expandtab\nset ai\nset autoindent\nset tabstop=4\nset paste\nset ruler\nsyntax on" > ~/.vimrc' && \
    su - ${USER} -c """echo $(echo "alias ll=\'ls -la --color=auto\'") >> ~/.bashrc""" && \
    su - ${USER} -c 'echo "cd '${REPO_PATH}'" >> ~/.bashrc' && \
    su - ${USER} -c 'echo "(git pull || true)" >> ~/.bashrc' && \
    su - ${USER} -c """echo $(echo 'export PATH="'${USER_HOME}'/.local/bin:'${PATH}'"') >> ~/.bashrc""" && \
    sed -i 's:/home/devel:/data:g' /etc/passwd && \
    echo ${CONTAINER_NAME} ${VERSION} > /etc/docker.type
COPY /start_container.sh /start_container.sh
#VOLUME ["/data"]
#WORKDIR ${REPO_PATH}
USER ${USER}
ENTRYPOINT ["/start_container.sh"]

# Gentoo Devel Container
  
FROM tuner/gentoo-skel:latest
ENV CONTAINER_NAME="devel" \
    USER="devel" \
    USER_HOME="/data" \
    MAIL="devel@localhost" \
    REPO_PATH="/data/devel" \
    PYTHONV="python3.6" \
    VERSION="1.1.3"
RUN useradd -d ${USER_HOME} -m -U -s /bin/bash ${USER} && \
    eselect python set "`eselect python list | grep ${PYTHONV} | awk '{ print $1 }' | grep -o '[0-9]'`" && \
    su - ${USER} -c "pip install --user setuptools django dotmap flask pymysql flask_restful cryptography urllib3" && \
    echo -e "set enc=utf-8\nset fenc=utf-8\nset termencoding=utf-8\nset expandtab\nset ai\nset autoindent\nset tabstop=4\n\"set paste\nset ruler\nsyntax on" > "${USER_HOME}/.vimrc" && \
    grep -qF "alias ll='ls -la --color=auto'" "${USER_HOME}/.bashrc" || echo "alias ll='ls -la --color=auto'" >> "${USER_HOME}/.bashrc" && \
    grep -qF "cd ${REPO_PATH}" "${USER_HOME}/.bashrc" || echo "cd ${REPO_PATH}" >> "${USER_HOME}/.bashrc" && \
    grep -qF "(git pull || true)" "${USER_HOME}/.bashrc" || echo "(git pull || true)" >> "${USER_HOME}/.bashrc" && \
    grep -qF 'export PATH="/home/'"${USER}"'/.local/bin:'"${PATH}"'"' "${USER_HOME}/.bashrc" || echo 'export PATH="/home/'"${USER}"'/.local/bin:'"${PATH}"'"' >> "${USER_HOME}/.bashrc" && \
    cp -pr ${USER_HOME} /home/devel.home/ && \
    echo ${CONTAINER_NAME} ${VERSION} > /etc/docker.type
COPY /start_container.sh /start_container.sh
VOLUME ["/data"]
#WORKDIR ${REPO_PATH}
USER ${USER}
ENTRYPOINT ["/start_container.sh"]

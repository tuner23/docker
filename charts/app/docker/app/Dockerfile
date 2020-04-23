# Gentoo Devel Container
  
FROM tuner/gentoo-skel:latest
ENV CONTAINER_NAME="app" \
    USER="app" \
    USER_HOME="/home/app" \
    MAIL="app@localhost" \
    WORK_PATH="/data" \
    PYTHONV="python3.6" \
    VERSION="1.1.3"
RUN useradd -d ${USER_HOME} -m -U -s /bin/bash ${USER} && \
    eselect python set "`eselect python list | grep ${PYTHONV} | awk '{ print $1 }' | grep -o '[0-9]'`" && \
    su - ${USER} -c "pip install --user setuptools django pymysql flask dotmap flask_restful cryptography urllib3" && \
    echo -e "set enc=utf-8\nset fenc=utf-8\nset termencoding=utf-8\nset expandtab\nset ai\nset autoindent\nset tabstop=4\nset paste\nset ruler\nsyntax on" > "${USER_HOME}/.vimrc" && \
    grep -qF "alias ll='ls -la --color=auto'" "${USER_HOME}/.bashrc" || echo "alias ll='ls -la --color=auto'" >> "${USER_HOME}/.bashrc" && \
    grep -qF "cd ${WORK_PATH}" "${USER_HOME}/.bashrc" || echo "cd ${WORK_PATH}" >> "${USER_HOME}/.bashrc" && \
    grep -qF 'export PATH="/home/'"${USER}"'/.local/bin:'"${PATH}"'"' "${USER_HOME}/.bashrc" || echo 'export PATH="/home/'"${USER}"'/.local/bin:'"${PATH}"'"' >> "${USER_HOME}/.bashrc" && \
    mkdir -p "${WORK_PATH}" && \
    chown "${USER}" "${WORK_PATH}" && \
    echo ${CONTAINER_NAME} ${VERSION} > /etc/docker.type
COPY /start_container.sh /start_container.sh
#VOLUME ["/data"]
#WORKDIR ${WORK_PATH}
USER ${USER}
ENTRYPOINT ["/start_container.sh"]

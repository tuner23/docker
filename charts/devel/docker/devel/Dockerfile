# Gentoo Devel Container
  
FROM tuner/devel-skel:latest
ENV CONTAINER_NAME="devel" \
    USER="devel" \
    USER_HOME="/home/devel" \
    MAIL="devel@localhost" \
    REPO_PATH="/data/evel" \
    PYTHONV="python3.6" \
    VERSION="1.1.3"
RUN useradd -m -U -s /bin/bash ${USER} && \
    eselect python set "`eselect python list | grep ${PYTHONV} | awk '{ print $1 }' | grep -o '[0-9]'`" && \
    su - ${USER} -c "pip install --user setuptools django" && \
    echo -e "set enc=utf-8\nset fenc=utf-8\nset termencoding=utf-8\nset expandtab\nset ai\nset autoindent\nset tabstop=4\nset paste\nset ruler\nsyntax on" > "${USER_HOME}/.vimrc" && \
    grep -qF "alias ll='ls -la --color=auto'" "${USER_HOME}/.bashrc" || echo "alias ll='ls -la --color=auto'" >> "${USER_HOME}/.bashrc" && \
    grep -qF "cd ${REPO_PATH}" "${USER_HOME}/.bashrc" || echo "cd ${REPO_PATH}" >> "${USER_HOME}/.bashrc" && \
    grep -qF "git pull" "${USER_HOME}/.bashrc" || echo "git pull" >> "${USER_HOME}/.bashrc" && \
    grep -qF 'export PATH="/home/'"${USER}"'/.local/bin:'"${PATH}"'"' "${USER_HOME}/.bashrc" || echo 'export PATH="/home/'"${USER}"'/.local/bin:'"${PATH}"'"' >> "${USER_HOME}/.bashrc" && \
    echo ${CONTAINER_NAME} ${VERSION} > /etc/docker.type
COPY /start_scripts/${CONTAINER_NAME}.start_container.sh /start_container.sh
VOLUME ["/data"]
WORKDIR ${REPO_PATH}
USER ${USER}
ENTRYPOINT ["/start_container.sh"]

# Gentoo Devel Container
  
FROM tuner/gentoo-skel:latest
ENV CONTAINER_NAME="app" \
    USER="app" \
    USER_HOME="/data" \
    MAIL="app@localhost" \
    PYTHONV="python3" \
    VERSION="2.0"
RUN useradd -d ${USER_HOME} -m -U -s /bin/bash ${USER} && \
    eselect python set "`eselect python list | grep ${PYTHONV} | awk '{ print $1 }' | grep -o '[0-9]'`" && \
    su - ${USER} -c "pip install --user setuptools django pymysql flask dotmap flask_restful cryptography urllib3 lark-parser" && \
    echo -e "set enc=utf-8\nset fenc=utf-8\nset termencoding=utf-8\nset expandtab\nset ai\nset autoindent\nset tabstop=4\nset paste\nset ruler\nsyntax on" > "${USER_HOME}/.vimrc" && \
    grep -qF "alias ll='ls -la --color=auto'" "${USER_HOME}/.bashrc" || echo "alias ll='ls -la --color=auto'" >> "${USER_HOME}/.bashrc" && \
    grep -qF "cd ${USER_HOME}" "${USER_HOME}/.bashrc" || echo "cd ${USER_HOME}" >> "${USER_HOME}/.bashrc" && \
    grep -qF 'export PATH="/home/'"${USER}"'/.local/bin:'"${PATH}"'"' "${USER_HOME}/.bashrc" || echo 'export PATH="/home/'"${USER}"'/.local/bin:'"${PATH}"'"' >> "${USER_HOME}/.bashrc" && \
    chown "${USER}" "${USER_HOME}" && \
    cd /root && tar -cvzf user_home.tgz -C /data ./ && \
    echo ${CONTAINER_NAME} ${VERSION} > /etc/docker.type
COPY /start_container.sh /start_container.sh
VOLUME ["/data"]
USER ${USER}
ENTRYPOINT ["/start_container.sh"]

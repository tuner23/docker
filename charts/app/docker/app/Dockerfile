# Gentoo Devel Container
  
FROM tuner/gentoo-skel:latest
ENV CONTAINER_NAME="app" \
    USER="app" \
    USER_HOME="/data" \
    MAIL="app@localhost" \
    PYTHONV="python3.7" \
    VERSION="2.0"
RUN useradd -m -U -s /bin/bash ${USER} && \
    #eselect python set "`eselect python list | grep ${PYTHONV} | awk '{ print $1 }' | grep -o '[0-9]'`" && \
    su - ${USER} -c 'pip install --user setuptools django pymysql flask dotmap flask_restful cryptography urllib3 lark-parser redis' && \
    su - ${USER} -c 'echo -e "set enc=utf-8\nset fenc=utf-8\nset termencoding=utf-8\nset expandtab\nset ai\nset autoindent\nset tabstop=4\nset paste\nset ruler\nsyntax on" > ~/.vimrc' && \
    su - ${USER} -c """echo $(echo "alias ll=\'ls -la --color=auto\'") >> ~/.bashrc""" && \
    su - ${USER} -c """echo $(echo 'export PATH="'${USER_HOME}'/.local/bin:'${PATH}'"') >> ~/.bashrc""" && \
    su - ${USER} -c 'echo "cd" >> ~/.bashrc' && \
    sed -i 's:/home/app:/data:g' /etc/passwd && \
    echo ${CONTAINER_NAME} ${VERSION} > /etc/docker.type
#COPY /start_container.sh /data/start_container.sh
#VOLUME ["/data"]
USER ${USER}
ENTRYPOINT ["/data/start_container.sh"]

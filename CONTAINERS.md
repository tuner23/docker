# Base Image
* The base image *tuner/gentoo-skel* is been build manually, due to the need of a privileged container for compilation
* Install from scratch (sth like..):
```
    docker run --privileged -ti gentoo/stage3-amd64:latest /bin/bash
    emerge --sync
    echo "dev-lang/python sqlite" >> /etc/portage/package.use/own
    echo 'alias ll="ls -lah --color=auto"' >> /etc/bash/bashrc 
    echo "net.ipv4.tcp_keepalive_time = 86400" >> /etc/sysctl.conf
    echo 'ACCEPT_KEYWORDS="~amd64"' >> /etc/portage/make.conf
    emerge -D --autounmask-write dev-util/jenkins-bin
    etc-update --automode -5
    emerge -avD dev-python/pip dev-lang/python dev-vcs/git dev-db/mysql app-editors/vim dev-util/jenkins-bin sys-cluster/kubernetes app-misc/jq dev-db/redis
    emerge --config dev-db/mysql
    rm -rf /var/db/repos/gentoo
    rm -rf /var/cache/distfiles/*
    docker commit -m "manually compiled" <IGAME_ID> tuner/gentoo-skel:latest
    docker login
    docker push tuner/gentoo-skel:latest
```

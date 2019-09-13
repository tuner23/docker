# Gentoo Git Container

FROM tuner/gentoo:latest
RUN eix-sync && \
    emerge -D dev-vcs/git
RUN rm /var/cache/eix/* && \
    rm -rf /usr/portage/* 


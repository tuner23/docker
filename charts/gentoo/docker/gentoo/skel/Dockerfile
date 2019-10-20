# Gentoo Base Container
## Include the portage tree
FROM gentoo/portage:latest as portage

## Use Gentoo stage3 as base image
FROM gentoo/stage3-amd64:latest

## Copy the portage tree into the current stage
COPY --from=portage /var/db/repos/gentoo /var/db/repos/gentoo

## Install some essentials
RUN echo 'alias ll="ls -lah --color=auto"' >> /etc/bash/bashrc && \
    emerge -D app-editors/vim dev-vcs/git

## Remove unnecessary stuff
RUN rm -rf /usr/share/doc/* && \
    rm -rf /usr/share/gtk-doc/* && \
    rm -rf /usr/share/info/* && \
    rm -rf /usr/share/man/*

## Do cleanup
RUN rm -rf /var/db/repos/gentoo	&& \
    rm -rf /var/cache/distfiles/*

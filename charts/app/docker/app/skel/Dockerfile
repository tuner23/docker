# Gentoo Devel Container
## Include the portage tree
FROM gentoo/portage:latest as portage

## Use the gentoo skel as base image  
FROM tuner/devel-skel:latest

## Copy the portage tree
COPY --from=portage /var/db/repos/gentoo /var/db/repos/gentoo

## Install devel tools
RUN emerge -D dev-db/mysql

## Do cleanup
RUN rm -rf /var/db/repos/gentoo/[a-l]* && \
    rm -rf /var/db/repos/gentoo/[n-o]* && \
    rm -rf /var/db/repos/gentoo/[q-v]* && \
    rm -rf /var/db/repos/gentoo/[x-z]* && \
    rm -rf /var/db/repos/gentoo/perl-core && \
    rm -rf /var/db/repos/gentoo/mail-* && \
    rm -rf /var/db/repos/gentoo/media-* && \
    rm -rf /var/db/repos/gentoo/mate-* && \
    rm -rf /var/cache/distfiles/*

# Gentoo Git Container
## Include the portage tree
FROM gentoo/portage:latest as portage

## Use the gentoo skel as base image
FROM tuner/gentoo-skel:latest

## Copy the portage tree
COPY --from=portage /var/db/repos/gentoo /var/db/repos/gentoo

## Install git
RUN grep -qF "dev-vcs/git -perl" /etc/portage/package.use/own || echo "dev-vcs/git -perl" >> /etc/portage/package.use/own && \
    emerge -D dev-vcs/git

## Do cleanup
RUN rm -rf /var/db/repos/gentoo && \
    rm -rf /var/cache/distfiles/*

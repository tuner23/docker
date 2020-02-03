# Gentoo Jenkins Container
## Include the portage tree
FROM gentoo/portage:latest as portage

## Use the gentoo skel as base image
# To build tuner/gentoo-jenkins:latest run
#     ./manage_docker.sh jenkins
FROM tuner/gentoo-jenkins:latest

## Copy the portage tree
COPY --from=portage /var/db/repos/gentoo /var/db/repos/gentoo

## Install Jenkins
#FROM tuner/gentoo-jenkins:latest
RUN (emerge -D --autounmask-write dev-util/jenkins-bin || true) && \
    etc-update --automode -5 && \
    emerge -D dev-util/jenkins-bin && \
    emerge -D app-misc/jq && \
    sys-cluster/kubectl

## Do cleanup
RUN rm -rf /var/db/repos/gentoo && \
    rm -rf /var/cache/distfiles/*

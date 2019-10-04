# Gentoo Jenkins Container

FROM tuner/gentoo-jenkins:latest
RUN eix-sync && \
    (vemerge -D --autounmask-write dev-java/openjdk-bin || true) && \
    etc-update --automode -5 && \
    emerge -D dev-java/openjdk-bin && \
    (emerge -D --autounmask-write dev-util/jenkins-bin || true) && \
    etc-update --automode -5 && \
    emerge -D dev-util/jenkins-bin && \
    emerge -D app-misc/jq
RUN rm /var/cache/eix/* && \
    rm -rf /usr/portage/* 


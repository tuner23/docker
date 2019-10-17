# Gentoo Git Container v2
# Use the empty image with the portage tree as the first stage
FROM gentoo/portage:latest as portage

# Gentoo stage3 is the second stage, basically an unpacked Gentoo Linux
FROM gentoo/stage3-amd64:latest

# Copy the portage tree into the current stage
COPY --from=portage /var/db/repos/gentoo /var/db/repos/gentoo

#FROM tuner/gentoo:latest
#RUN emerge -D dev-vcs/git app-editors/vim app-portage/eix
#RUN rm /var/cache/eix/* && \
#    rm -rf /usr/portage/* 
RUN echo 'alias ll="ls -lah --color=auto"' >> /etc/bash/bashrc && \
    emerge -D app-editors/vim 

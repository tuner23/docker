# Gentoo Devel Container
  
FROM tuner/gentoo:latest
RUN eix-sync && \
    grep -qF "dev-lang/python sqlite" /etc/portage/package.use/own || echo "dev-lang/python sqlite" >> /etc/portage/package.use/own && \
    emerge -D dev-python/pip dev-lang/python
RUN rm /var/cache/eix/* && \
    rm -rf /usr/portage/*

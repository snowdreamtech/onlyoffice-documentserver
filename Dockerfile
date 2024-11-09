FROM onlyoffice/documentserver:8.2.0

# OCI annotations to image
LABEL org.opencontainers.image.authors="Snowdream Tech" \
    org.opencontainers.image.title="Ubuntu Base Image" \
    org.opencontainers.image.description="Docker Images for onlyoffice/documentserver. (linux/amd64,linux/arm64)" \
    org.opencontainers.image.documentation="https://hub.docker.com/r/snowdreamtech/onlyoffice-documentserver" \
    org.opencontainers.image.base.name="snowdreamtech/onlyoffice-documentserver:latest" \
    org.opencontainers.image.licenses="AGPL-3.0" \
    org.opencontainers.image.source="https://github.com/snowdreamtech/onlyoffice-documentserver" \
    org.opencontainers.image.vendor="Snowdream Tech" \
    org.opencontainers.image.version="8.2.0" \
    org.opencontainers.image.url="https://github.com/snowdreamtech/onlyoffice-documentserver"

ENV DEBIAN_FRONTEND=noninteractive \
    # keep the docker container running
    KEEPALIVE=1 \
    # Ensure the container exec commands handle range of utf8 characters based of
    # default locales in base image (https://github.com/docker-library/docs/tree/master/ubuntu#locales)
    LANG=C.UTF-8 

RUN set -eux \
    && apt-get -qqy update  \
    && apt-get -qqy install --no-install-recommends \ 
    procps \
    sudo \
    vim \ 
    unzip \
    tzdata \
    openssl \
    wget \
    curl \
    iputils-ping \
    lsof \
    apt-transport-https \
    ca-certificates \                                                                                                                                                                                                      
    && update-ca-certificates\
    && apt-get -qqy --purge autoremove \
    && apt-get -qqy clean \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /tmp/* \
    && rm -rf /var/tmp/* \
    && echo 'export PROMPT_COMMAND="history -a; $PROMPT_COMMAND"' >> /etc/bash.bashrc 

RUN set -eux \
    wget -c https://github.com/snowdreamtech/onlyoffice-core-fonts/archive/refs/heads/main.zip -O main.zip \
    && unzip main.zip \
    && mkdir -p /usr/share/fonts/truetype/custom/snowdreamtech \ 
    && mv onlyoffice-core-fonts-main/* /usr/share/fonts/truetype/custom/snowdreamtech/ \
    && rm -rfv main.zip \
    && rm -rfv onlyoffice-core-fonts-main

COPY vimrc.local /etc/vim/vimrc.local

COPY docker-entrypoint.sh /usr/local/bin/

ENTRYPOINT ["docker-entrypoint.sh"]
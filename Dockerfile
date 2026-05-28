FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    curl \
    wget \
    unzip \
    build-essential \
    libssl-dev \
    zlib1g-dev \
    && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /opt/mtproto \
    && cd /opt/mtproto \
    && curl -sL https://github.com/TelegramMessenger/MTProxy/archive/refs/heads/master.zip -o master.zip \
    && unzip -q master.zip \
    && cd MTProxy-master \
    && make \
    && cp objs/bin/mtproto-proxy /usr/local/bin/

COPY .devcontainer/entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]

FROM debian:bookworm-slim

LABEL maintainer="@Kakoolnews" \
      description="Telegram MTProto Proxy via GitHub Codespaces"

COPY install.sh /app/install.sh

WORKDIR /app

RUN apt-get update && apt-get install -y --no-install-recommends \
    bash git curl wget unzip tzdata openssl ca-certificates uuid-runtime \
    python3 python3-pip \
    && rm -rf /var/lib/apt/lists/*

RUN chmod +x /app/install.sh && /app/install.sh

COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

HEALTHCHECK --interval=30s --timeout=5s --start-period=10s --retries=3 \
    CMD curl -sf http://localhost:443/ || exit 1

CMD ["/usr/local/bin/entrypoint.sh"]

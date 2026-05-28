#!/bin/sh

# Download pre-built MTProxy binary
if [ ! -f /usr/local/bin/mtproto-proxy ]; then
    echo "Downloading MTProxy..."
    curl -sL "https://github.com/TelegramMessenger/MTProxy/releases/download/2.0.0/mtproto-proxy-linux-x86_64" -o /usr/local/bin/mtproto-proxy || \
    curl -sL "https://github.com/9seconds/mtg/releases/latest/download/mtg" -o /usr/local/bin/mtproto-proxy
    chmod +x /usr/local/bin/mtproto-proxy
fi

# Check if binary is valid
if ! file /usr/local/bin/mtproto-proxy | grep -q "ELF"; then
    echo "Download failed, trying alternative..."
    rm -f /usr/local/bin/mtproto-proxy
    curl -sL "https://github.com/9seconds/mtg/releases/latest/download/mtg" -o /usr/local/bin/mtproto-proxy
    chmod +x /usr/local/bin/mtproto-proxy
fi

# Generate random secret (32 hex chars)
SECRET=$(od -An -tx1 -N16 /dev/urandom | tr -d ' \n')

# Port configuration
PORT="${PROXY_PORT:-443}"

# Get official Telegram tag
TAG=$(curl -s "https://core.telegram.org/getProxySecret" | od -An -tx1 | tr -d ' \n' | head -c 32)

echo "========================================"
echo "  @KakoolNews - Telegram MTProto Proxy"
echo "========================================"
echo ""
echo "Secret: $SECRET"
echo "Port: $PORT"
echo ""
echo "TG Proxy Link:"
echo "tg://proxy?server=$CODESPACE_NAME-443.app.github.dev&port=$PORT&secret=$SECRET"
echo ""
echo "========================================"
echo "Proxy running..."
echo ""

# Run MTProxy
/usr/local/bin/mtproto-proxy \
    -u root \
    -p 8888 \
    -H $PORT \
    -M 1 \
    -S "$SECRET" \
    --domain-fronting 2>&1 || \
/usr/local/bin/mtproto-proxy \
    -u root \
    -p 8888 \
    -H $PORT \
    -M 1 \
    -S "$SECRET" 2>&1

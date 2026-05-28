#!/bin/sh

mkdir -p /opt/mtproto

# Download pre-built MTProxy binary
if [ ! -f /usr/local/bin/mtproto-proxy ]; then
    echo "Downloading MTProxy..."
    cd /opt/mtproto
    curl -sL https://github.com/TelegramMessenger/MTProxy/releases/latest/download/mtproto-proxy-linux-x86_64 -o mtproto-proxy
    chmod +x mtproto-proxy
    mv mtproto-proxy /usr/local/bin/
fi

# Generate random secret (32 hex chars)
SECRET=$(od -An -tx1 -N16 /dev/urandom | tr -d ' \n')

# Port configuration
PORT="${PROXY_PORT:-443}"

# Get official Telegram tag (optional - helps with connectivity)
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
    --aes-pwd /etc/proxy-secret \
    -S "$SECRET" \
    --domain-fronting \
    2>&1

# If domain fronting fails, try without
echo "Trying alternative mode..."
/usr/local/bin/mtproto-proxy \
    -u root \
    -p 8888 \
    -H $PORT \
    -M 1 \
    -S "$SECRET" \
    2>&1

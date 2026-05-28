#!/bin/sh

# Build MTProxy from source if not present
if [ ! -f /usr/local/bin/mtproto-proxy ]; then
    echo "Installing build tools..."
    apt-get update && apt-get install -y build-essential libssl-dev zlib1g-dev wget unzip curl git 2>/dev/null || true
    
    echo "Building MTProxy from source..."
    cd /tmp
    rm -rf MTProxy
    git clone https://github.com/TelegramMessenger/MTProxy.git
    cd MTProxy
    make
    cp objs/bin/mtproto-proxy /usr/local/bin/
    chmod +x /usr/local/bin/mtproto-proxy
fi

# Get existing secret or generate new one
if [ -f /tmp/proxy_secret ]; then
    SECRET=$(cat /tmp/proxy_secret)
else
    SECRET=$(od -An -tx1 -N16 /dev/urandom | tr -d ' \n')
    echo "$SECRET" > /tmp/proxy_secret
fi

# Port configuration
PORT="${PROXY_PORT:-443}"

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

# Run MTProxy in background
/usr/local/bin/mtproto-proxy \
    -u root \
    -p 8888 \
    -H $PORT \
    -M 1 \
    -S "$SECRET" \
    -d 2>&1

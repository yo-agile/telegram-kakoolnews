#!/bin/bash

# Install Python and mtprotoproxy if not present
if [ ! -f /usr/local/bin/mtprotoproxy ]; then
    echo "Installing Python and mtprotoproxy..."
    apt-get update && apt-get install -y python3 python3-pip 2>/dev/null || true
    pip3 install mtprotoproxy 2>/dev/null || python3 -m pip install mtprotoproxy 2>/dev/null || true
    cp $(which mtprotoproxy) /usr/local/bin/mtprotoproxy 2>/dev/null || true
fi

# Generate secret
SECRET=$(openssl rand -hex 16 2>/dev/null || cat /dev/urandom | od -An -tx1 | tr -d ' \n' | head -c 32)

# Port configuration
PORT="${PROXY_PORT:-3128}"

echo "========================================"
echo "  @KakoolNews - Telegram Proxy"
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

# Run the proxy
mtprotoproxy --port $PORT --secret "$SECRET" &

sleep 2
tail -f /dev/null

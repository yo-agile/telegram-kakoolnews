#!/bin/bash

# Install Python and mtprotoproxy
pip3 install mtprotoproxy 2>/dev/null || python3 -m pip install mtprotoproxy

# Generate secret
SECRET=$(openssl rand -hex 16 2>/dev/null || cat /dev/urandom | od -An -tx1 | tr -d ' \n' | head -c 32)
PORT=3128

echo "========================================"
echo "  @KakoolNews - Telegram Proxy"
echo "========================================"
echo ""
echo "Link: tg://proxy?server=$CODESPACE_NAME-443.app.github.dev&port=$PORT&secret=$SECRET"
echo ""
echo "Proxy running..."

# Run
mtprotoproxy --port $PORT --secret "$SECRET" &

# Keep terminal open
tail -f /dev/null

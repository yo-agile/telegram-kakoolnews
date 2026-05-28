#!/bin/sh
set -eu

MTPROXY_DIR="/usr/local/bin"
MTPROXY_REPO="https://github.com/alexbers/mtprotoproxy.git"

echo "Installing MTProto Proxy..."

# Clone or update mtprotoproxy
if [ -d "/tmp/mtprotoproxy" ]; then
    echo "Updating mtprotoproxy..."
    cd /tmp/mtprotoproxy && git pull
else
    echo "Cloning mtprotoproxy..."
    cd /tmp && git clone "$MTPROTO_REPO"
fi

# Create launcher script
cat > "$MTPROXY_DIR/mtprotoproxy.sh" << 'SCRIPT'
#!/bin/sh
# MTProto Proxy Launcher
# Usage: mtprotoproxy.sh [port] [secret]
# Default: port 443, secret from environment or auto-generated

PORT="${1:-443}"
SECRET="${2:-$(openssl rand -hex 16 2>/dev/null || od -An -tx1 -N16 /dev/urandom | tr -d ' \n')}"

cd /tmp/mtprotoproxy
exec /usr/bin/python3 mtprotoproxy.py "$PORT" "$SECRET"
SCRIPT

chmod +x "$MTPROXY_DIR/mtprotoproxy.sh"

echo "MTProto Proxy installed successfully."

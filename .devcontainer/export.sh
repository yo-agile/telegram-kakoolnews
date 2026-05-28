#!/bin/sh
# Export script for Telegram MTProto proxy
# Generates proxy links for importing in Telegram

set -eu

OUTPUT_DIR="/workspaces/telegram-proxy/.devcontainer/output"

# Default values
SERVER_IP="${SERVER_IP:-localhost}"
SERVER_PORT="${SERVER_PORT:-443}"

# Generate MTProto secret
MTPROTO_SECRET="${MTPROTO_SECRET:-$(openssl rand -hex 16 2>/dev/null || od -An -tx1 -N16 /dev/urandom | tr -d ' \n')}"

export_config() {
    mkdir -p "$OUTPUT_DIR"
    
    # Telegram proxy links
    cat > "$OUTPUT_DIR/proxy_links.txt" << EOF
========================================
  @KakoolNews - Telegram MTProto Proxy
========================================

MTProto Secret: dd${MTPROTO_SECRET}

Proxy Links:
tg://proxy?server=${SERVER_IP}&port=${SERVER_PORT}&secret=dd${MTPROTO_SECRET}

HTTPS Import Links:
https://t.me/proxy?server=${SERVER_IP}&port=${SERVER_PORT}&secret=dd${MTPROTO_SECRET}
========================================
EOF
    
    # JSON config for reference
    cat > "$OUTPUT_DIR/config.json" << EOF
{
  "server": "${SERVER_IP}",
  "port": ${SERVER_PORT},
  "secret": "dd${MTPROTO_SECRET}",
  "remark": "@KakoolNews Telegram Proxy"
}
EOF
    
    echo "Configs exported to $OUTPUT_DIR/"
    echo ""
    echo "Files created:"
    echo "  - proxy_links.txt  (Telegram proxy links)"
    echo "  - config.json     (JSON config reference)"
}

# Run if executed directly
export_config

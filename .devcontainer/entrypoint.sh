#!/bin/sh

# MTProto Telegram Proxy Setup
# Based on alexbers/mtprotoproxy
# Works with GitHub Codespaces on same IPs as g2ray

# Public IPs (GitHub-hosted runners)
IP1="20.90.66.7"
IP2="20.103.221.187"

# Generate MTProto secret (32 hex characters)
SECRET=$(openssl rand -hex 16 2>/dev/null || od -An -tx1 -N16 /dev/urandom | tr -d ' \n')

# Get internal IP of the container
INTERNAL_IP=$(hostname -I 2>/dev/null | awk '{print $1}' || curl -s ifconfig.me 2>/dev/null || echo "localhost")

# Get codespace name for SNI
CODESPACE_NAME="${CODESPACE_NAME:-localhost}"
CODESSPACE_DOMAIN="${CODESPACE_NAME}-443.app.github.dev"

bytes_to_human() {
    local b=$1
    if [ "$b" -lt 1024 ]; then echo "${b}B"
    elif [ "$b" -lt 1048576 ]; then echo "$((b / 1024))KB"
    elif [ "$b" -lt 1073741824 ]; then echo "$(echo "scale=1; $b / 1048576" | bc 2>/dev/null || echo "$((b / 1048576))")MB"
    else echo "$(echo "scale=2; $b / 1073741824" | bc 2>/dev/null || echo "$((b / 1073741824))")GB"
    fi
}

show_usage() {
    rx=0 tx=0
    for iface in eth0 ens enp; do
        if [ -f "/sys/class/net/$iface/statistics/rx_bytes" ]; then
            rx=$((rx + $(cat /sys/class/net/$iface/statistics/rx_bytes 2>/dev/null || echo 0)))
            tx=$((tx + $(cat /sys/class/net/$iface/statistics/tx_bytes 2>/dev/null || echo 0)))
        fi
    done
    [ "$rx" -eq 0 ] && rx=$(awk '/^(eth0|ens|enp)/ {rx+=$2} END {print rx+0}' /proc/net/dev 2>/dev/null || echo "0")
    [ "$tx" -eq 0 ] && tx=$(awk '/^(eth0|ens|enp)/ {tx+=$10} END {print tx+0}' /proc/net/dev 2>/dev/null || echo "0")
    echo "[$(date '+%H:%M:%S')] Download: $(bytes_to_human $rx) | Upload: $(bytes_to_human $tx) | Total: $(bytes_to_human $((rx + tx)))"
}

echo "========================================"
echo "  @KakoolNews - Telegram MTProto Proxy"
echo "========================================"
echo ""
echo "MTProto Secret: dd${SECRET}"
echo "Internal IP: ${INTERNAL_IP}"
echo "Codespace: ${CODESSPACE_DOMAIN}"
echo ""
echo "Proxy Links (use these in Telegram):"
echo "tg://proxy?server=${CODESSPACE_DOMAIN}&port=443&secret=dd${SECRET}"
echo ""
echo "Alternative IP Links (if domain doesn't work):"
echo "tg://proxy?server=${IP1}&port=443&secret=dd${SECRET}"
echo "tg://proxy?server=${IP2}&port=443&secret=dd${SECRET}"
echo ""
echo "HTTPS Links (for import):"
echo "https://t.me/proxy?server=${CODESSPACE_DOMAIN}&port=443&secret=dd${SECRET}"
echo "========================================"
echo ""
echo "Restart: pkill -f mtprotoproxy.py; /usr/local/bin/mtprotoproxy.sh &"
echo ""

# Make port 443 public
if command -v gh &> /dev/null && [ -n "$CODESPACE_NAME" ]; then
    gh codespace ports visibility 443:public -c "$CODESPACE_NAME" 2>/dev/null || true
fi

# Start MTProto proxy on 0.0.0.0 to accept external connections
cd /tmp/mtprotoproxy
/usr/bin/python3 mtprotoproxy.py 443 "$SECRET" &

show_usage

while true; do
    sleep 120
    show_usage
done

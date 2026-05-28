#!/bin/sh

# MTProto Telegram Proxy Setup
# Based on alexbers/mtprotoproxy

IP1="20.90.66.7"
IP2="20.103.221.187"

# Generate MTProto secret (32 hex characters)
SECRET=$(openssl rand -hex 16 2>/dev/null || od -An -tx1 -N16 /dev/urandom | tr -d ' \n')

# Get codespace name for SNI
CODESPACE_NAME="${CODESPACE_NAME:-localhost}"

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
echo ""
echo "Proxy Links (use any):"
echo "tg://proxy?server=${IP1}&port=443&secret=dd${SECRET}"
echo "tg://proxy?server=${IP2}&port=443&secret=dd${SECRET}"
echo ""
echo "HTTPS Links (for import):"
echo "https://t.me/proxy?server=${IP1}&port=443&secret=dd${SECRET}"
echo "https://t.me/proxy?server=${IP2}&port=443&secret=dd${SECRET}"
echo "========================================"
echo ""
echo "Restart: pkill -f mtprotoproxy.py; /usr/local/bin/mtprotoproxy.sh &"
echo ""

# Start MTProto proxy
/usr/local/bin/mtprotoproxy.sh &

show_usage

while true; do
    sleep 120
    show_usage
done

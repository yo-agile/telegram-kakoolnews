#!/bin/sh

# Install mtprotoproxy
apt-get update && apt-get install -y python3 python3-pip git
pip3 install mtprotoproxy --break-system-packages 2>/dev/null || true

# Clone mtprotoproxy if pip fails
if ! command -v mtprotoproxy &> /dev/null; then
    cd /tmp && rm -rf mtprotoproxy && git clone https://github.com/alexbers/mtprotoproxy.git
fi

CONFIG_TEMPLATE="/etc/config.template.json"
CONFIG="/etc/config.json"

generate_uuid() {
    prefix="4b616b6f-6f6c-4e65-7773"
    suffix=$(od -An -tx1 -N6 /dev/urandom | tr -d ' \n')
    echo "${prefix}-${suffix}"
}

UUID="4b616b6f-6f6c-4e65-7773-b8e2c9f3d541"
sed "s/\${UUID}/$UUID/g" "$CONFIG_TEMPLATE" > "$CONFIG"

SNI="${CODESPACE_NAME:-localhost}-443.app.github.dev"
IP1="20.90.66.7"
IP2="20.103.221.187"

SECRET=$(openssl rand -hex 16 2>/dev/null || od -An -tx1 -N16 /dev/urandom | tr -d ' \n')

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
echo "  @KakoolNews - VLESS + MTProto Proxy"
echo "========================================"
echo ""
echo "VLESS UUID: $UUID"
echo "TG Secret: $SECRET"
echo ""
echo "VLESS Links:"
echo "vless://${UUID}@${IP1}:443?encryption=none&security=tls&type=ws&sni=${SNI}&path=%2F#@Kakoolnews"
echo "vless://${UUID}@${IP2}:443?encryption=none&security=tls&type=ws&sni=${SNI}&path=%2F#@Kakoolnews"
echo ""
echo "Telegram Proxy Links:"
echo "tg://proxy?server=${IP1}&port=443&secret=dd${SECRET}"
echo "tg://proxy?server=${IP2}&port=443&secret=dd${SECRET}"
echo "========================================"
echo ""

# Start VLESS proxy
/usr/local/bin/xray -c "$CONFIG" &

# Start Telegram proxy (use python3 directly)
/usr/bin/python3 /tmp/mtprotoproxy/mtprotoproxy.py 443 "$SECRET" &

show_usage

while true; do
    sleep 120
    show_usage
done

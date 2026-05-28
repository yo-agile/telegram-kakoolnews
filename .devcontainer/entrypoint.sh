#!/bin/sh

# HTTP Proxy Setup via Xray
# Works with GitHub Codespaces - same IPs as g2ray

CONFIG_TEMPLATE="/etc/config.template.json"
CONFIG="/etc/config.json"

# Public IPs (GitHub-hosted runners)
IP1="20.90.66.7"
IP2="20.103.221.187"

# Get codespace info
CODESPACE_NAME="${CODESPACE_NAME:-localhost}"
CODESPACE_DOMAIN="${CODESPACE_NAME}-443.app.github.dev"

# Generate random password
PASSWORD=$(openssl rand -base64 24 2>/dev/null || cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 24 | head -1)

# Replace placeholder in config
sed "s/\${PASSWORD}/$PASSWORD/g" "$CONFIG_TEMPLATE" > "$CONFIG"

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
echo "  @KakoolNews - HTTP Proxy"
echo "========================================"
echo ""
echo "Server: ${CODESPACE_DOMAIN}"
echo "Port: 443"
echo "Username: telegram"
echo "Password: ${PASSWORD}"
echo ""
echo "HTTP Proxy Links:"
echo "http://telegram:${PASSWORD}@${CODESPACE_DOMAIN}:443"
echo ""
echo "IP Alternative:"
echo "http://telegram:${PASSWORD}@${IP1}:443"
echo "http://telegram:${PASSWORD}@${IP2}:443"
echo ""
echo "HTTPS (with TLS):"
echo "https://telegram:${PASSWORD}@${CODESPACE_DOMAIN}:443"
echo "========================================"
echo ""
echo "Restart: pkill xray; /usr/local/bin/xray -c /etc/config.json &"
echo ""

# Start Xray HTTP proxy
/usr/local/bin/xray -c "$CONFIG" &

show_usage

while true; do
    sleep 120
    show_usage
done

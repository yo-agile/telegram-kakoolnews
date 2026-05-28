# @KakoolNews Telegram MTProto Proxy

> Automated MTProto Telegram proxy setup via GitHub Codespaces — works anywhere Codespaces is available.

## Warning

**Use a secondary GitHub account (not your main account)** when forking and running this project. Running proxy servers may trigger GitHub's automated security systems or account restrictions.

## Features

- **Auto-generated Secret** — each Codespace session gets a unique MTProto secret
- **MTProxy Support** — uses official Telegram MTProto proxy protocol
- **Multi-architecture** — supports amd64, arm64, and armv7
- **Traffic stats** — built-in bandwidth monitoring
- **Health checks** — built-in Docker health monitoring
- **Same IPs as g2ray** — runs on the same reliable IPs:
  - `20.90.66.7`
  - `20.103.221.187`

## Quick Start

1. Fork this repository (use a secondary account)
2. Click **Code** > **Codespaces** > **Create codespace on main**
3. Wait 2–5 minutes for setup to complete
4. Copy the MTProto link printed in the terminal
5. Import in Telegram: **Settings** → **Proxy** → **Add Proxy**

### Import the Proxy Link

Use the **Codespace domain link** (recommended):
```
tg://proxy?server=<codespace>-443.app.github.dev&port=443&secret=dd<generated>
```

Or use the alternative IP links:
```
tg://proxy?server=20.90.66.7&port=443&secret=dd<generated>
tg://proxy?server=20.103.221.187&port=443&secret=dd<generated>
```

## Configuration

### MTProto Secret

The secret is auto-generated at startup. Each Codespace gets a unique 32-character hex secret.

### Proxy Port

| Setting | Value | Description |
|---------|-------|-------------|
| Port | 443 | MTProto proxy port |
| Protocol | MTProto | Telegram proxy protocol |
| Secret | Auto-generated | 32-char hex string |

## Codespace Quota

GitHub provides **120 free core-hours/month**:

| Cores | Hours/Month |
|-------|-------------|
| 2 | 60 |
| 4 | 30 |
| 8 | 15 |

**Stop your Codespace when not in use** to conserve hours.

## Compatible Networks

Tested with Shecan (free plan). These IPs are reachable from most Iranian networks:

- `20.90.66.7`
- `20.103.221.187`

## Troubleshooting

| Problem | Solution |
|---------|---------|
| Codespace fails to start | Delete it and create a new one |
| No proxy link shown | Check the terminal output for errors |
| Connection timeout | Try a different datacenter or ISP |
| Port not accessible | Ensure port 443 is set to public visibility |
| Telegram shows "Not Available" | Use the Codespace domain link instead of IP |
| Telegram can't connect | Ensure you're using the `dd` prefix in secret |

### Port Visibility

Make sure port 443 is set to **Public** in Codespaces:
1. Go to your Codespace
2. Click on the **Ports** tab
3. Find port 443
4. Set visibility to **Public**

The entrypoint will attempt to set this automatically, but you can verify it manually.

## Project Structure

```
.devcontainer/
  Dockerfile          # Container image definition
  config.json         # MTProxy configuration template
  devcontainer.json   # Codespace settings and lifecycle hooks
  entrypoint.sh       # Startup script: generates secret, configures MTProxy, prints links
  install.sh          # Downloads and installs mtprotoproxy
docs/
  screenshot.png      # Terminal screenshot for reference
```

## Support

- [Buy me a coffee](https://www.buymeacoffee.com/amiremohamadi)
- Ethereum: `0x5724c38100b2aE3d2547974f46D0f2f49eb2D152`

## Disclaimer

This tool is for educational and legitimate use only. Users are responsible for complying with local laws and regulations regarding proxy usage. The author is not responsible for any misuse.

## License

This project is open-source. See the LICENSE file for details.

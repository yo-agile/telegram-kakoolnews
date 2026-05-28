# @KakoolNews HTTP Proxy

> Automated HTTP Proxy setup via GitHub Codespaces — works anywhere Codespaces is available.
> Compatible with Telegram and other apps that support HTTP proxy.

## Warning

**Use a secondary GitHub account (not your main account)** when forking and running this project. Running proxy servers may trigger GitHub's automated security systems or account restrictions.

## Features

- **Auto-generated Password** — each Codespace session gets a unique credentials
- **HTTP Proxy** — works with Telegram and any HTTP proxy-compatible app
- **Multi-architecture** — supports amd64, arm64, and armv7
- **Traffic stats** — built-in bandwidth monitoring
- **Same IPs as g2ray** — runs on the same reliable IPs:
  - `20.90.66.7`
  - `20.103.221.187`

## Quick Start

1. Fork this repository (use a secondary account)
2. Click **Code** > **Codespaces** > **Create codespace on main**
3. Wait 2–5 minutes for setup to complete
4. Copy the proxy credentials from the terminal
5. Configure your app to use HTTP proxy

### Telegram Setup

1. Open Telegram
2. Go to **Settings** → **Data and Storage** → **Proxy Settings**
3. Click **Add Proxy**
4. Select **HTTP**
5. Enter:
   - Server: `<codespace>-443.app.github.dev`
   - Port: `443`
   - Username: `telegram`
   - Password: (copy from terminal)

## Proxy Credentials

| Setting | Value |
|---------|-------|
| Server | `<codespace>-443.app.github.dev` |
| Port | 443 |
| Username | `telegram` |
| Password | (auto-generated) |

### Alternative IPs

If the domain doesn't work from your network:
- `20.90.66.7`
- `20.103.221.187`

## Codespace Quota

GitHub provides **120 free core-hours/month**:

| Cores | Hours/Month |
|-------|-------------|
| 2 | 60 |
| 4 | 30 |
| 8 | 15 |

**Stop your Codespace when not in use** to conserve hours.

## Troubleshooting

| Problem | Solution |
|---------|---------|
| Codespace fails to start | Delete it and create a new one |
| Connection timeout | Try the alternative IPs |
| Port not accessible | Ensure port 443 is set to public visibility |
| Proxy not working | Check username/password are correct |

## Project Structure

```
.devcontainer/
  Dockerfile          # Container image definition with Xray
  config.json         # Xray HTTP proxy configuration
  devcontainer.json   # Codespace settings and lifecycle hooks
  entrypoint.sh       # Startup script: generates credentials, starts Xray
  install.sh          # Downloads and installs Xray-core
```

## Support

- [Buy me a coffee](https://www.buymeacoffee.com/amiremohamadi)
- Ethereum: `0x5724c38100b2aE3d2547974f46D0f2f49eb2D152`

## Disclaimer

This tool is for educational and legitimate use only. Users are responsible for complying with local laws and regulations regarding proxy usage. The author is not responsible for any misuse.

## License

This project is open-source. See the LICENSE file for details.

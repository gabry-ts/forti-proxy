# forticlient-proxy

Route any app through a Fortinet IPsec VPN — without installing FortiClient.

[![CI](https://github.com/gabry-ts/forti-proxy/actions/workflows/ci.yml/badge.svg)](https://github.com/gabry-ts/forti-proxy/actions/workflows/ci.yml)
![Docker](https://img.shields.io/badge/Docker-ready-blue.svg)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](./LICENSE)

## Why

FortiClient is bloated, installs kernel extensions, and takes over your whole system. Sometimes you just need to route specific traffic through a corporate VPN.

**forticlient-proxy** runs a Fortinet IPsec VPN client inside Docker and exposes it as HTTP and SOCKS5 proxies. Point any app at `localhost:1080` and its traffic goes through the VPN. Everything else stays on your normal connection.

## Quick Start

### Using the pre-built image

```bash
docker pull ghcr.io/gabry-ts/forti-proxy:latest
```

### Building locally

```bash
git clone https://github.com/gabry-ts/forti-proxy.git
cd forticlient-proxy

# Configure your VPN credentials
cp config/ipsec.conf.template config/ipsec.conf
cp config/ipsec.secrets.template config/ipsec.secrets
# Edit both files with your gateway, username, PSK, and password

docker compose up -d
```

## Proxy Endpoints

| Protocol | Address | Use case |
|----------|---------|----------|
| SOCKS5 | `localhost:1080` | Browsers, SSH, curl (`--proxy socks5://localhost:1080`) |
| HTTP | `localhost:1090` | Apps that only support HTTP proxies |

## How It Works

```mermaid
graph LR
    A[Your apps<br>browser, curl, etc] -->|SOCKS5 :1080<br>HTTP :1090| B[Docker container<br>strongSwan + microsocks + tinyproxy]
    B -->|IPsec VPN<br>UDP 500/4500| C[Corporate<br>network]
```

The container runs:
- **strongSwan** — IPsec VPN client (aggressive mode + XAuth)
- **microsocks** — lightweight SOCKS5 proxy
- **tinyproxy** — HTTP proxy

All proxy traffic is routed through the VPN tunnel via iptables.

## Configuration

Edit `config/ipsec.conf`:
```
conn fortinet
    right=YOUR_GATEWAY        # VPN server IP
    xauth_identity=YOUR_USERNAME
```

Edit `config/ipsec.secrets`:
```
: PSK "YOUR_PRESHARED_KEY"
YOUR_USERNAME : XAUTH "YOUR_PASSWORD"
```

> **Never commit these files.** They are in `.gitignore`.

## Use Cases

- Access corporate resources without installing FortiClient
- Route only specific traffic through VPN (split tunneling by app)
- Run VPN access in CI/CD pipelines
- Use on Linux servers where FortiClient is not available
- Keep your host system clean from VPN client bloat

## License

[MIT](./LICENSE)

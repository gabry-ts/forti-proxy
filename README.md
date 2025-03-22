# Fortinet VPN Proxy Docker Setup

This repository contains Docker configuration for creating a Fortinet IPsec VPN client container with built-in HTTP and SOCKS5 proxy capabilities.

## Directory Structure

```
fortinet-vpn-proxy/
├── Dockerfile
├── config/
│   ├── ipsec.conf.template
│   └── ipsec.secrets.template
├── scripts/
│   └── start.sh
└── docker-compose.yml
```

## Setup Instructions

1. Clone this repository
2. Create your configuration files from the templates:

```bash
cp config/ipsec.conf.template config/ipsec.conf
cp config/ipsec.secrets.template config/ipsec.secrets
```

3. Edit the configuration files with your VPN credentials:
   - In `config/ipsec.conf`: 
     - Replace `YOUR_GATEWAY` with your VPN gateway IP address
     - Replace `YOUR_USERNAME` with your VPN username
   - In `config/ipsec.secrets`: 
     - Replace `YOUR_PRESHARED_KEY` with your VPN pre-shared key
     - Replace `YOUR_PASSWORD` with your VPN password

4. Build and run the container:

```bash
docker-compose up -d
```

## Configuration Details

### IPsec Configuration

The VPN uses IPsec with the following parameters:
- VPN Type: IPsec
- Connection Method: Aggressive Mode
- Authentication: Pre-shared key + XAuth

**Important Security Note:** The configuration files contain sensitive credentials. Never commit the populated configuration files to a public repository.

### Exposed Services

The container exposes the following services:
- IPsec VPN (UDP ports 500, 4500)
- HTTP Proxy (TCP port 8080, mapped to 1090)
- SOCKS5 Proxy (TCP port 1080)

## Usage

Once the container is running, you can configure your applications to use:
- SOCKS5 proxy at `localhost:1080`
- HTTP proxy at `localhost:1090`

All traffic through these proxies will be routed through the VPN connection.
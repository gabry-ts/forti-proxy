# base image
FROM debian:bullseye

# install required packages
RUN apt-get update && apt-get install -y \
    strongswan \
    iproute2 \
    iptables \
    build-essential \
    git \
    tinyproxy \
    && apt-get clean

# install microsocks (lightweight socks5 server)
RUN git clone https://github.com/rofl0r/microsocks.git /tmp/microsocks && \
    cd /tmp/microsocks && \
    make && \
    mv microsocks /usr/local/bin/ && \
    cd / && \
    rm -rf /tmp/microsocks

# configure tinyproxy to listen on all interfaces and allow all connections
RUN sed -i 's/Listen 127.0.0.1/Listen 0.0.0.0/' /etc/tinyproxy/tinyproxy.conf && \
    sed -i 's/Port 8888/Port 8080/' /etc/tinyproxy/tinyproxy.conf && \
    echo "Allow 0.0.0.0/0" >> /etc/tinyproxy/tinyproxy.conf

# copy vpn configuration files
COPY config/ipsec.conf /etc/ipsec.conf
COPY config/ipsec.secrets /etc/ipsec.secrets
COPY scripts/start.sh /start.sh

# make startup script executable
RUN chmod +x /start.sh

# expose ports (500/4500 for vpn, 1080 for socks5, 8080 for http proxy)
EXPOSE 500/udp 4500/udp 1080 8080

# start services
CMD ["/start.sh"]
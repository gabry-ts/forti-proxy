#!/bin/bash

# start vpn
ipsec start --nofork &

# wait for vpn connection
sleep 10

# start socks5 proxy
microsocks -i 0.0.0.0 -p 1080 &

# start http proxy
service tinyproxy start

# keep container running
tail -f /dev/null
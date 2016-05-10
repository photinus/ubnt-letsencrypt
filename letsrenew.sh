#!/bin/bash

# Opening up firewall on port 80
CHAIN=$( iptables -L | awk '/^Chain WAN/ && /LOCAL/ {print $2;}' )
iptables -I $CHAIN 1 -p tcp --dport 80 -j ACCEPT

# Run renewal script
python /config/letsencrypt/acme_tiny.py --account-key /config/letsencrypt/account.key --csr /config/letsencrypt/domain.csr --acme-dir /var/www/htdocs/.well-known/acme-challenge/ > /config/letsencrypt/signed.crt

# Removing firewall rule added earlier
iptables -D $CHAIN 1

# Copying files to lighttpd directory
cat /config/letsencrypt/signed.crt > /etc/lighttpd/server.pem
cat /config/letsencrypt/domain.key >> /etc/lighttpd/server.pem

# Restarting lighttpd daemon
ps -e | grep lighttpd | awk '{print $1;}' | xargs kill
/usr/sbin/lighttpd -f /etc/lighttpd/lighttpd.conf

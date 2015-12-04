#!/bin/bash
python /opt/letsencrypt/acme_tiny.py --account-key /opt/letsencrypt/account.key --csr /opt/letsencrypt/domain.csr --acme-dir /var/www/htdocs/.well-known/acme-challenge/ > /opt/letsencrypt/signed.crt

cat /opt/letsencrypt/signed.crt > /etc/lighttpd/server.pem
cat /opt/letsencrypt/domain.key >> /etc/lighttpd/server.pem

ps -e | grep lighttpd | awk '{print $1;}' | xargs kill
/usr/sbin/lighttpd -f /etc/lighttpd/lighttpd.conf

#!/bin/bash

mkdir -p /var/www/htdocs/.well-known/acme-challenge/
ln -sf /config/lighttpd/lighttpd.conf /etc/lighttpd/lighttpd.conf
ln -sf /config/letsencrypt/letsrenew.sh /etc/cron.monthly/letsrenew.sh

cat /config/letsencrypt/signed.crt > /etc/lighttpd/server.pem
cat /config/letsencrypt/domain.key >> /etc/lighttpd/server.pem

ps -e | grep lighttpd | awk '{print $1;}' | xargs kill
/usr/sbin/lighttpd -f /etc/lighttpd/lighttpd.conf
#!/bin/bash

mkdir -p /var/www/htdocs/.well-known/acme-challenge/
ln -sf /config/lighttpd/lighttpd.conf /etc/lighttpd/lighttpd.conf
ln -sf /config/letsencrypt/letsrenew.sh /etc/cron.monthly/letsrenew.sh

cat /config/letsencrypt/signed.crt | tee /etc/lighttpd/server.pem
cat /config/letsencrypt/domain.key | tee -a /etc/lighttpd/server.pem

cat /var/run/lighttpd.pid | xargs kill
/usr/sbin/lighttpd -f /etc/lighttpd/lighttpd.conf

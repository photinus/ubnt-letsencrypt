#!/bin/bash

# Input regarding FQDN which will be used
read -p "Enter your full FQDN:" fqdn

# Creating persistant letsencrypt directories and downloading files
mkdir /config/letsencrypt/
curl -o /config/letsencrypt/acme_tiny.py https://raw.githubusercontent.com/diafygi/acme-tiny/master/acme_tiny.py
chmod 755 /config/letsencrypt/acme_tiny.py
curl -o /config/letsencrypt/letsrenew.sh https://raw.githubusercontent.com/rholmboe/ubnt-letsencrypt/master/letsrenew.sh
chmod 755 /config/letsencrypt/letsrenew.sh
ln -sf /config/letsencrypt/letsrenew.sh /etc/cron.monthly/letsrenew.sh
curl -o /config/scripts/post-config.d/install_letsencrypt.sh https://raw.githubusercontent.com/rholmboe/ubnt-letsencrypt/master/install_letsencrypt.sh
chmod 755 /config/scripts/post-config.d/install_letsencrypt.sh

# Generate certifications which will be used
openssl genrsa 4096 | tee /config/letsencrypt/account.key
openssl genrsa 4096 | tee /config/letsencrypt/domain.key
openssl req -new -sha256 -key /config/letsencrypt/domain.key -subj "/CN=$fqdn" | tee /config/letsencrypt/domain.csr

# Making lighttpd configurations and restarting daemon
mkdir /config/lighttpd/
curl -o /config/lighttpd/lighttpd.conf https://raw.githubusercontent.com/rholmboe/ubnt-letsencrypt/master/lighttpd.conf
ln -sf /config/lighttpd/lighttpd.conf /etc/lighttpd/lighttpd.conf
ps -e | grep lighttpd | awk '{print $1;}' | xargs kill
/usr/sbin/lighttpd -f /etc/lighttpd/lighttpd.conf

# Create acme respons directory
mkdir -p /var/www/htdocs/.well-known/acme-challenge/

# Run letsrenew.sh file for initial connect and/or renewal, doesn't matter
bash /config/letsencrypt/letsrenew.sh

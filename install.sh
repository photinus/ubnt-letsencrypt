#!/bin/bash

fatal(){
  echo "$@"
  exit 1
}

[ -z $1 ] && fatal "you must provide the public hostname of your edgerouter"

fqdn=$1

# Creating persistant letsencrypt directories and downloading files
[ -d /config/letsencrypt ] || mkdir /config/letsencrypt/
cp /etc/lighttpd/server.pem /config/letsencrypt/oldcert.pem
curl -o /config/letsencrypt/acme_tiny.py https://raw.githubusercontent.com/diafygi/acme-tiny/master/acme_tiny.py
chmod 755 /config/letsencrypt/acme_tiny.py
curl -o /config/letsencrypt/letsrenew.sh https://raw.githubusercontent.com/rholmboe/ubnt-letsencrypt/master/letsrenew.sh
chmod 755 /config/letsencrypt/letsrenew.sh
ln -sf /config/letsencrypt/letsrenew.sh /etc/cron.monthly/letsrenew.sh
curl -o /config/scripts/post-config.d/install_letsencrypt.sh https://raw.githubusercontent.com/rholmboe/ubnt-letsencrypt/master/install_letsencrypt.sh
chmod 755 /config/scripts/post-config.d/install_letsencrypt.sh

echo "Generate keys to be used in our signed certificate"
[ -f /config/letsencrypt/account.key ] || openssl genrsa 4096 | tee /config/letsencrypt/account.key
[ -f /config/letsencrypt/domain.key ]  || openssl genrsa 4096 | tee /config/letsencrypt/domain.key
[ -f /config/letsencrypt/domain.csr ]  || openssl req -new -sha256 -key /config/letsencrypt/domain.key -subj "/CN=$fqdn" | tee /config/letsencrypt/domain.csr

echo "Making lighttpd configurations and restarting daemon so letsencypt and verify we own this domain via .well-known/acme-challenge/"
[ -d /config/lighttpd ] ||  mkdir /config/lighttpd/
curl -o /config/lighttpd/lighttpd.conf https://raw.githubusercontent.com/rholmboe/ubnt-letsencrypt/master/lighttpd.conf
ln -sf /config/lighttpd/lighttpd.conf /etc/lighttpd/lighttpd.conf
ps -e | grep lighttpd | awk '{print $1;}' | xargs kill
/usr/sbin/lighttpd -f /etc/lighttpd/lighttpd.conf

# Create acme respons directory
[ -d /var/www/htdocs/.well-known/acme-challenge/ ] || mkdir -p /var/www/htdocs/.well-known/acme-challenge/

echo "Run letsrenew.sh file to actually sign the certificate and generate new /etc/lighttpd/server.pem"
bash /config/letsencrypt/letsrenew.sh






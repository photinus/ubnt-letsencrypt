#!/usr/bin/env bash


cd /tmp

echo " generate private key with no prompts"
openssl req -newkey rsa:2048 -passout pass:'1234' -out self.csr -keyout temp.key -subj "/C=US/ST=CA/L=San Jose/O=Ubiquiti Networks/CN=UBNT Router UI"

echo " strip out passphrase from key"
openssl rsa -in temp.key -passin pass:'1234' -out self.key

echo "generate self sign"
openssl x509 -req -days 10950 -signkey self.key -in self.csr -out self.crt

echo " concatenate key and cert into a webserver loadable file"
cat self.crt > server.pem
cat self.key >> server.pem

echo " copy new cert back into lighty dir"
cp server.pem /etc/lighttpd/server.pem

echo "restart lighty"
/usr/sbin/lighttpd -f /etc/lighttpd/lighttpd.conf

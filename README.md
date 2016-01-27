# How to setup Let's Encrypt with the Ubiquiti Edge Router Lite

Disclaimer:
> You will be modifying some of the inner workings of your edgerouter. This could break your router. I believe the steps I ouline here are generally safe, but you will be issuing commands as root and can do damage easily. Be careful.

For starters, You'll need:
* acme_tiny.py, you can find it here: https://github.com/diafygi/acme-tiny
* SSH Access to your Edgerouter
* A FQDN for your edge router that is accessable externally
* Port 80 open to your edge router externally

Please note you are opening your edgerouter to the outside world. Please use common sense and use a strong password and common security best practices.

Start by connecting to your edgerouter via SSH and issue the command 
```bash
sudo -i
```
Let's setup a base directory to work with
```bash
mkdir /opt/letsencrypt
cd /opt/letsencrypt
curl -O https://raw.githubusercontent.com/diafygi/acme-tiny/master/acme_tiny.py
```
Now we're going to do some initial setup for Let's Encrypt
```bash
openssl genrsa 4096 > account.key
openssl genrsa 4096 > domain.key
```
Next, replace "yoursite.com" with your edge routers FQDN
```bash
openssl req -new -sha256 -key domain.key -subj "/CN=**yoursite.com**" > domain.csr
```
Now that we've got the basics ready, this is where we will tweak the ubiquiti stock setup to allow us to use Let's Encrypt.
```bash
mkdir -p /var/www/htdocs/.well-known/acme-challenge/
```
We need to edit the Ubiquiti lighttpd configuration. You can either edit your existing configuration to change:
```apache
url.rewrite-once = ( 
        "^(/(lib|media|ws|tests)/.*)" => "$0",
        "^/([^\?]+)(\?(.*))?$" => "/index.php/$1?$3"
) 

$HTTP["scheme"] == "http" { 
    $HTTP["url"] !~ "^/index.php/error/" { 
        $HTTP["host"] =~ "^(.*)$" { 
                url.redirect = ( 
                        "^(.*)$" => "https://%1$1"
                ) 
        } 
    } 
  } 
} 
```
into
```apache
url.rewrite-once = ( 
        "^(/(lib|media|ws|tests|.well-known)/.*)" => "$0",
        "^/([^\?]+)(\?(.*))?$" => "/index.php/$1?$3"
) 

$HTTP["scheme"] == "http" { 
  $HTTP["url"] !~ "^/.well-known/acme-challenge/*" { 
    $HTTP["url"] !~ "^/index.php/error/" { 
        $HTTP["host"] =~ "^(.*)$" { 
          url.redirect = ( 
            "^(.*)$" => "https://%1$1"
          ) 
        } 
    } 
  } 
} 
```

Now we've got the foundation for our Let's Encrypt setup. Next we restart lighttpd to pick up the new configuration file and then we'll get our first certificate.

Restarting Lighttpd
```bash
ps -e | grep lighttpd | awk '{print $1;}' | xargs kill
/usr/sbin/lighttpd -f /etc/lighttpd/lighttpd.conf
```

Generating our first certificate
```bash
python /opt/letsencrypt/acme_tiny.py \
  --account-key /opt/letsencrypt/account.key \
  --csr /opt/letsencrypt/domain.csr \
  --acme-dir /var/www/htdocs/.well-known/acme-challenge/ \
  > /opt/letsencrypt/signed.crt
```

Now, if that worked without any issue, we can setup our cron script and run it for the first time to put our new certificate in place. Just place a copy of letsrenew.sh into your /etc/cron.monthly directory and chmod 755 it.

If everything went well you should have a shiny green lock icon next time you visit your Edgerouter's GUI.

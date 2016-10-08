# Persistent Let's Encrypt with the Ubiquiti Edge Router Lite

Originally by photinus
Modified by [rholmboe](https://github.com/rholmboe/)

Disclaimer:
> You will be modifying some of the inner workings of your edgerouter. This could break your router. I believe the steps I outline here are generally safe, but you will be issuing commands as root and can do damage easily. Be careful.

For starters, You'll need:
* SSH Access to your Edgerouter
* https://github.com/diafygi/acme-tiny ( pulled in by this script )
* A FQDN for your edge router that is accessable externally
* Firewall rules that allow access to your web ui

Please note you are opening your edgerouter to the outside world. Please use common sense and use a strong password and common security best practices.

## Installation

Ensure you have firewall rules in place to allow remote access and a strong password:- e.g.

```
set firewall name WAN_LOCAL rule 15 action accept
set firewall name WAN_LOCAL rule 15 description "Allow Remote WEBUI"
set firewall name WAN_LOCAL rule 15 log disable
set firewall name WAN_LOCAL rule 15 destination port 443
set firewall name WAN_LOCAL rule 15 protocol tcp
```

SSH into your EdgeRouter and issue following command

```
curl https://raw.githubusercontent.com/photinus/ubnt-letsencrypt/master/install.sh | sudo bash /dev/stdin public.dynamic.dns.of.your.router
```
*Important* change public.dynamic.dns.of.your.router to whatever yours is!

If everything went well you should have a shiny green lock icon next time you visit your Edgerouter's GUI.

## Renewal

Because letsencrpt certificates expire a renewal cronjob is setup by this script

## Restoring

If you have any problems then you can restore a self signed certificate with the restore.sh script


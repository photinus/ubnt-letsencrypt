# Persistant Let's Encrypt with the Ubiquiti Edge Router Lite

Disclaimer:
> You will be modifying some of the inner workings of your edgerouter. This could break your router. I believe the steps I outline here are generally safe, but you will be issuing commands as root and can do damage easily. Be careful.

For starters, You'll need:
* SSH Access to your Edgerouter
* acme_tiny.py, you can find it here: https://github.com/diafygi/acme-tiny
* A FQDN for your edge router that is accessable externally

Please note you are opening your edgerouter to the outside world. Please use common sense and use a strong password and common security best practices.

## Installation

SSH into your EdgeRouter and issue following command

```
curl https://raw.githubusercontent.com/photinus/ubnt-letsencrypt/master/install.sh | sudo bash
```
*Important* is to enter your external FQDN

If everything went well you should have a shiny green lock icon next time you visit your Edgerouter's GUI.

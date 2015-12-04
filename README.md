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
> sudo -i
Most of what we'll be doing requires Root access. Now we'll need to install wget
> apt-get install wget
Let's setup a base directory to work with
> mkdir /opt/letsencrypt

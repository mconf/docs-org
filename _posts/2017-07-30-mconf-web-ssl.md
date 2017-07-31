---
date: 2017-01-30
title: Mconf-Web with HTTPS
categories:
  - Mconf-Web
description: How to configure SSL (HTTPS) in Mconf-Web
type: Document
---

This page describes how to enable SLL/HTTPS in your Mconf-Web server. It assumes you already have an instance of Mconf-Web working in production mode.

## Certificate

The first thing you need is a SSL certificate. There is plenty of information about it in the Internet (just search for "SSL certificate"), but the fastest way to get things going is to create a self-signed [certificate](http://en.wikipedia.org/wiki/Self-signed_certificate self-signed). See below how to do it (with instructions taken from [this page](http://wiki.rnp.br/pages/viewpage.action?pageId=41616278) -- in Portuguese).

Copy the following content to a file named `/tmp/openssl.conf`, replacing all comments between `<` and `>` by the appropriate values.

```
[ req ]
default_bits = 2048 # Size of keys
string_mask = nombstr # permitted characters
distinguished_name = req_distinguished_name

[ req_distinguished_name ]
# Variable name   Prompt string
#----------------------   ----------------------------------
0.organizationName = <Name of your organization>
organizationalUnitName = <Department in your organization>
organizationalUnitName_default = <Same as above>
emailAddress = <Email address>
emailAddress_max = 40
localityName = <City name>
stateOrProvinceName = <State name>
countryName = <Country name (2 letters)>
countryName_default = <Same as above>
countryName_min = 2
countryName_max = 2
commonName = <Host name including the domain>
commonName_default = <Same as above>
commonName_max = 64
```

Generate the key with the commands below (replace `$HOSTNAME` by the name of your host, e.g. `myserver.com`):

```bash
$ sudo openssl genrsa -out /etc/ssl/private/$HOSTNAME.key 2048 -config /tmp/openssl.conf
$ sudo openssl req -new -key /etc/ssl/private/$HOSTNAME.key -out /etc/ssl/private/$HOSTNAME.csr -batch -config /tmp/openssl.conf
$ sudo openssl x509 -req -days 730 -in /etc/ssl/private/$HOSTNAME.csr -signkey /etc/ssl/private/$HOSTNAME.key -out /etc/ssl/certs/$HOSTNAME.crt
```

Your self-signed certificate will be at: `/etc/ssl/certs/$HOSTNAME.crt`.

And now you can remove the `/tmp/openssl.conf` file:

```bash
$ rm /tmp/openssl.conf
```

## Configuring Apache

At first, enable some modules that will be needed:

```bash
$ sudo a2enmod ssl
$ sudo a2enmod rewrite
```

There will be a configuration file to listen to requests on port 80 and rewrite them all to port 443. If you already have Mconf-Web running, you will already have a configuration file that should be at `/etc/apache2/sites-enabled/mconf-web`. Edit this file to include the contents of: https://github.com/mconf/mconf-web/blob/v2.0.x/config/webserver/apache2_ssl_80.example (replace `YOUR_HOST` by your server's name or IP).

You can also download the new file and replace the old one -- **be careful!** -- with:

```bash
$ sudo wget https://raw.github.com/mconf/mconf-web/v2.0.x/config/webserver/apache2_ssl_80.example -O /etc/apache2/sites-available/mconf-web.conf
```

Then install the configuration file that will respond to requests on port 443:

```bash
$ sudo wget https://raw.github.com/mconf/mconf-web/v2.0.x/config/webserver/apache2_ssl_443.example -O /etc/apache2/sites-available/mconf-web-ssl.conf
```

In this file (`/etc/apache2/sites-available/mconf-web-ssl`) you will have to edit all occurrences of `YOUR_IP`, `YOUR_HOST`, `YOUR_CERT` and `/somewhere/public` by the appropriate values.


Enable the new configuration file:

```bash
$ sudo a2ensite mconf-web-ssl
```

Restart Apache:

```bash
$ sudo service apache2 restart
```

## Configuring the application

After enabling SSL in your server, you have to configure Mconf-Web to use it. You can either access the [[management page|Configuring-the-Website]] (that might not be accessible now) or do it from your terminal with:

```bash
$ cd /home/mconf/mconf-web/current
./script/rails runner -e production "Site.current.update_attributes(:ssl => true)"
```

This will update the attribute that informs the application to use SSL. The application should already work even if this flag is not set, but still you need to set it so the application can generate correct links (i.e. using HTTPS instead of HTTP) when sending emails, for instance.

## Firewall

HTTPS uses port 443, so make sure it is not blocked in your firewall.

If you're using iptables, you can add the following lines to your `/etc/default/firewall` to allow HTTP and HTTPS:

```bash
iptables -A INPUT -p tcp -m tcp --dport   80 -j ACCEPT
iptables -A INPUT -p tcp -m tcp --dport  443 -j ACCEPT
```

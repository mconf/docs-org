---
date: 2017-01-30
title: Mconf-Web with Shibboleth
categories:
  - Mconf-Web
description: How to configure Shibboleth in Mconf-Web
type: Document
---

## Introduction

Shibboleth is a solution that allows federated "single sign-in". In brief, this is how it works:
* Users access services provided by "service providers" (e.g. a web application like Mconf-Web), but their authentication is made through an entity called "identity provider".
* The service provider redirects the users to the identity provider, the user enters his credentials, the identity provider validates the credentials and redirects the user back to the service provider.
* The service provider receives just a controlled set of information of the user, such as his name and email. This means that the user will trust his credentials to the identity provider only, and not to the service providers.

You can read more about it [here](http://shibboleth.net/) and [here](http://en.wikipedia.org/wiki/Shibboleth_(Internet2)).


## A brief description of how it works on Mconf-Web

Most of the implementation of Shibboleth on Mconf-Web is done by using the Shibboleth module for Apache (`mod_shib2`). Once the Shibboleth module is installed and configured, when a user is redirected to the url `/secure` in your Mconf-Web server, Apache will redirect the user to the identity provider configured. After the authentication is done in the service and identity providers, the user is redirected back to Mconf-Web.

Mconf-Web will have access only to the information the identity provider returns. With this information a new account will be created automatically for the user. This happens only in the first access: in subsequent accesses the user will just access his account that was already created. On the first access the user has also the option to associate his federated account with an account on Mconf-Web, in case the user already had an account created on Mconf-Web.


## Install and configure Apache's Shibboleth module

The configuration of a Shibboleth service provider is usually different for different federations. Some steps are shared in all installations, but some others are unique and depend on how the federation is configured. In this page we will show a guide with all the steps we use to configure Mconf-Web for the Brazilian federation [CAFe](http://portal.rnp.br/web/servicos/cafe), that was used while the integration with Shibboleth was implemented in Mconf-Web. You can use it as a guide, but we strongly recommend also getting help from the people responsible for the federation you want to integrate Mconf-Web with and review every step while executing this guide.

This guide is strongly based on: http://wiki.rnp.br/pages/viewpage.action?pageId=41616305

### Prerequisites

* You need a server with Mconf-Web up and running. See [[this guide|Deployment]].
* Your Mconf-Web server needs to be using HTTPS (SSL). See [[this guide|SSL]].

### Installation

Install Apache's module for Shibboleth:

```bash
$ sudo apt-get install libapache2-mod-shib2
```

Enable it:

```bash
$ sudo a2enmod shib2
```

### Configuration

You need to configure your site in Apache to trigger the Shibboleth authentication when users access the path `/secure`. To do that, add the contents of the file [`config/webserver/apache2_shibboleth.example`](https://github.com/mconf/mconf-web/blob/v2.0.x/config/webserver/apache2_shibboleth.example) to the bottom of your `/etc/apache2/sites-available/mconf-web-ssl`, just before the closing `</VirtualHost>` tag.

Then configure how the Shibboleth module will communicate with the identity provider. **This step will probably be different for other federations**, this is just and example of what has to be configured.

Download these files (if they already exist, you will be replacing them):

```bash
$ sudo wget https://raw.github.com/mconf/mconf-web/v2.0.x/config/shibboleth/cafe/shibboleth2.xml -O /etc/shibboleth/shibboleth2.xml
$ sudo wget https://raw.github.com/mconf/mconf-web/v2.0.x/config/shibboleth/cafe/attribute-map.xml -O /etc/shibboleth/attribute-map.xml
$ sudo wget https://raw.github.com/mconf/mconf-web/v2.0.x/config/shibboleth/cafe/attribute-policy.xml -O /etc/shibboleth/attribute-policy.xml
```

Open `/etc/shibboleth/shibboleth2.xml` and replace:

* `$DOMAIN` by you server's domain, e.g. `server.institution.com`.


### Metadata

Create a metadata file that will added in the metadata pool in your identity provider so that your application to be able to access it. The format of this file will probably be different for different federations.

To use our example metadata, first download it:

```bash
$ sudo wget https://raw.github.com/mconf/mconf-web/v2.0.x/config/shibboleth/cafe/metadata-sp.xml -O /root/metadata-sp.xml
```

There are several things to be edited in this file. It should be very straightforward, you just have to edit everything that starts with a `$`. Some examples for the values that should be added to this metadata file:

* `$DOMAIN`: server.my-institution.com;
* `$INSTITUTION`: My Institution;
* `$INSTITUTION_DOMAIN`: my-institution.com.
* `$SERVICE_NAME`: My Web Conference Service.
* `$SERVICE_DESCRIPTION`: The best web conference server around.
* `$ADMIN_NAME`: John Doe.
* `$ADMIN_EMAIL`: john@my-institution.com.

You can leave the `$CERTIFICATE` part as it is for now, we will fill it up soon.


### Certificate

You need a certificate to link to your Shibboleth installation. You can generate one with the command below. Replace `$DOMAIN` by your server's domain (e.g. `server.my-institution.com`).

```bash
$ sudo shib-keygen -y 3 -h $DOMAIN -e https://$DOMAIN/shibboleth
```

This command will create two files: `/etc/shibboleth/sp-key.pem` and `/etc/shibboleth/sp-cert.pem`. If you used the configuration files above, these certificates files will already be referenced in the section `CredentialResolver` of `/etc/shibboleth/shibboleth2.xml`. Otherwise, change it to be like the example below:

```xml
<CredentialResolver type="File" key="sp-key.pem"
                    certificate="sp-cert.pem" keyName="$DOMAIN"/>
```

At last, edit `/root/metadata-sp.xml` once again and replace the block with `$CERTIFICATE` by the contents of `/etc/shibboleth/sp-cert.pem`. Make sure you **do not** include the first and last lines, the ones with `-----BEGIN CERTIFICATE-----` and `-----END CERTIFICATE-----`.


## Enable and configure Shibboleth inside Mconf-Web

Having your server configured, you now have to enable and configure Shibboleth inside Mconf-Web.

Go to the [[management area|Configuring-the-Website#management-area]] and you will see some parameters used to configure Shibboleth. They are:

* **Enable Shibboleth**: If checked it will enable the login via Shibboleth and add information in the interface for the user to select it.
* **Shibboleth environment variables**: When the identity provider returns the user's information to Mconf-Web, they will be stored in environment variables. You can define in this field the name of the variables that will be read and stored within the session. If left empty, all variables that start with `shib-` will be fetched.
* **Shibboleth field for email**: The name of the field that will be used as the user's email.
* **Shibboleth field for name**: The name of the field that will be used as the user's full name.
* **Shibboleth field for principal name (unique ID)**: The name of the field that will be used to get the "principal name" of the user. This should be a field that contains only unique values, since it will be used to identify the user. Several academic institutions use the "eduPerson-principalName" (EPPN) as the unique attribute, and this is why we call it "principal name" here. If you don't use it, you could very well use the same field as the email field, as long as the emails are unique. Note that Mconf-Web cannot deal with changes in the "principal name" in the federation, since it is used as the identifier internally.
* **Shibboleth field for login**: The name of the field that will be used as the user's login. if not informed, the login will be generated from the user's name. This field doesn't have to contain "login-like" values; the value will be adapted to be a valid login by Mconf-Web (e.g. "My Name" is changed to "my-name").
* **Shibboleth: always create new account**: If this flag is set, when a user signs in via Shibboleth, Mconf-Web will automatically create an account for the user; there will be no option to associate the Shibboleth credentials with an existent account.
* **Shibboleth: update users**: If this flag is set, some of the user information will be automatically updated on Mconf-Web right before the user signs in via Shibboleth. So if the user's email changes in the federation, for example, it will be automatically updated on Mconf-Web. As of now, the attributes that are updated are the email and the full name. If this feature is on, users will not be able to edit these attributes via Mconf-Web (so the email and full name inputs will be disabled).

You can see in the picture below an example of how these fields can be configured:

![Example of the configurations for Shibboleth](https://github.com/mconf/mconf-web/wiki/images/site-shib-example.png "Example of the configurations for Shibboleth")

---
date: 2017-01-30
title: Mconf-Web with LDAP
categories:
  - Mconf-Web
description: How to configure LDAP in Mconf-Web
type: Document
---

## Basics

LDAP is treated as a module in Mconf-Web. It can be easily disabled and enabled by an administrator. If enabled LDAP will **always** be used as the first authentication mechanism. If the login fails via LDAP, it falls back to the local authentication, so it is transparent to the user. If the user is signed in via LDAP, he can see a message telling him of that in his account page.

Internally, Mconf-Web automatically creates a user account for the user in his first connection via LDAP. This account has a random password that should not be used to log in using the local authentication (even though it could be used).

## Server configuration

If you do not want to connect to LDAP using LDAPS (secure connection) you can skip this section and move to the "Website configuration" section.

If you choose to enable LDAPS you must follow these two steps, they are:

* Step 1 - Configure the file `/etc/ldap/ldap.conf`
  * In this file you should put the full path where you're going to place the certificate for the ldap server;
* Step 2 - Place the certificate for the LDAP server
  * Now you must place the certificate on the specified path chosen on the latter step (step 1).

For now this is all that is necessary to be done to successfully connect to a LDAP server using LDAPS (port 636) to create a secure connection to the server.

## Website configuration

To be able to use authentication via LDAP you must set some variables that are going to define the correct usage of the LDAP server and its data. To set these variables, go to the management page ([read more about it here](Configuring-the-Website)). The variables are:

* `LDAP: Enable authentication`: Check it to enable authentication via LDAP. If checked, LDAP will **always** be used as the first authentication mechanism. If the login fails via LDAP, it falls back to the local authentication.
* `LDAP: Server IP or domain`: Insert the IP or domain of the LDAP server (e.g. '192.111.22.33' or 'ldapserver.any.com').
* `LDAP: Server port`: Insert the port which will be used to connect to the LDAP server (for LDAPS connection use 636).
* `LDAP: Full DN for the user`: Insert the full DN (Distinguished Name) of the user to be used to connect to the LDAP server.
* `LDAP: User password`: Insert the password for the user that is going to access the LDAP server.
* `LDAP: Full DN for UsersTreebase`: This specifies the LDAP branch (DN) where the users that need to authenticate are located.
* `LDAP: Field to obtain the username`: Specifies which attribute returned by LDAP will be used to obtain the username of a user (e.g.: 'uid').
* `LDAP: Field to obtain the user's email`: Specifies which attribute returned by LDAP will be used to obtain the email of a user (e.g.: 'mail').
* `LDAP: Field to obtain the user's full name`: Specifies which attribute returned by LDAP will be used to obtain the full name of a user (e.g.: 'cn').

Once all options are set, the authentication via LDAP will be enabled. Every time a user tries to log in, the application will first try to authenticate him against the LDAP server. If it fails for some reason, it falls back to the local authentication.

If you have problems, check your log for messages starting with `LDAP:`. They are added by the authentication class, that can be found [here](https://github.com/mconf/mconf-web/blob/v2.0.x/lib/devise/strategies/ldap_authenticatable.rb).

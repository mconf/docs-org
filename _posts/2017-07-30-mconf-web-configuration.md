---
date: 2017-01-30
title: Configuring Mconf-Web
categories:
  - Mconf-Web
description: How to configure Mconf-Web
type: Document
---

## About

Mconf-Web stores all its configurations in a database and provides a management interface in the website where an admin user can edit most of these configurations. All important site-wide configurations are available in this management page. If you can't find an option you need, feel free to require a change posting an issue in our [issue tracker](https://github.com/mconf/mconf-web/issues).

There are basically 3 ways to configure the website:

* Using the management area in the website: **this is what you should do**, see more about it below;
* Pre-populate the database before creating it, using `setup_conf.yml` file: useful for development or to setup more than one website (see more about it at the end of this page);
* Hacking the source code and directly editing the database: you'll only need to do it if you need to change something that is not yet configurable using the management page. You'll also need knowledge in Rails and the internals of Mconf-Web.

It is also important to point out that the majority of the things you change in the configurations of Mconf-Web will require a [restart]({% post_url 2017-07-30-mconf-web-deploy %}#restart) in the application.


## Management area

When you first setup Mconf-Web, an administrator user will be created. The default username, email and password are defined in the `setup_conf.yml`. By default these configurations are:

* email: `admin@default.com`
* login: `admin`
* password: `admin`

Log in with this user and you will have access to the management area using a link in the top bar:

![Top bar management link](https://github.com/mconf/mconf-web/wiki/images/manage-link.png "Top bar management link")

Clicking on this link will take you to the page with the website's configurations. It will look similar to the image below:

![Website configuration page](https://github.com/mconf/mconf-web/wiki/images/site-show.png "Website configuration page")

Clicking in the "Edit" button at the bottom of the page will take you to the page to edit these configurations. When viewing or editing the configurations, use the help icons to get more information about each option:

![Tips on the configuration page](https://github.com/mconf/mconf-web/wiki/images/site-edit-tooltip.png "Tips on the configuration page")

Some of the most important things to edit are the username and the password of the email account that will be used to send all emails generated in Mconf-Web (registration confirmations, password resets, web conference invitations, and others). You can configure any SMTP account (by default we use a Gmail account). Changing any property related to this require you to restart the server to take effect.

The attributes currently available to be configured in this page are:

* `Name`: The name of your website.
* `Description`: A description for your website.
* `Application Domain`: The domain of your server (e.g. `my-server.com`).
* `Language`: Default language for your website (e.g. `en`).
* `Visible languages`: Check the languages you wish to use in the website.
* `Timezone`: Default timezone for the website. Will be used for all users that have not set their timezone.
* `Signature`: Signature used in emails sent from your website.
* `SSL`: Mark if you need to use SSL/HTTPS in your website. This is necessary so the application can generate links with HTTPS instead of HTTP when necessary (e.g. in emails that have links to the application).
* `Feedback URL`: URL that will be opened after a user logs out of a conference (e.g. a Google Drive doc such as `https://docs.google.com/spreadsheet/viewform?hl=en_US&pli=1&formkey=123456789123456789#gid=0`).
* `Automatically set the recording flag when creating a web conference`: If checked, the recording flag will be set according to the recording permission of the user that is creating the conference. If unchecked, users that have permission to record will see a popup to choose to record or not when creating a conference.
* `Analytics Code`: Code for Google Analytics (e.g. `UA-12345678-9`).
* `Shibboleth: Enable`: Mark if you want to allow shibboleth login in your website.
* `Shibboleth environment variables`: Shibboleth variables that the application will read from the environment (e.g. `shib-.*`).
* `Shibboleth field for email`: Shibboleth variable that will be used as the user's email (e.g. `Shib-inetOrgPerson-mail`).
* `Shibboleth field for name`: Shibboleth variable that will be used as the user's name (e.g. `Shib-inetOrgPerson-sn`).
* `Shibboleth field for principal name`: Shibboleth variable that will be used to get the user's identifier in the federation. Some federations use the email as the identifier, so you could set here the same attribute used for the email (e.g. `Shib-inetOrgPerson-mail`). Is used to identify the user on sign in.
* `Shibboleth field for login`: Shibboleth variable that will be used as the user's login (e.g. `Shib-inetOrgPerson-id`).
* `LDAP: Enable authentication:` Mark if you want to allow login via LDAP in your website.
* `LDAP: Server IP or domain:` Insert the IP or domain of the LDAP server (e.g. '192.111.22.33' or 'ldapserver.any.com').
* `LDAP: Server port:` Insert the port which will be used to connect to the LDAP server (for LDAPS connection use 636).
* `LDAP: Full DN for the user:` Insert the full DN (Distinguished Name) of the user to be used to connect to the LDAP server.
* `LDAP: User password:` Insert the password for the user that is going to access the LDAP server.
* `LDAP: Full DN for UsersTreebase:` This specifies the LDAP branch (DN) where the users that need to authenticate are located.
* `LDAP: Field to obtain the username:` Specifies which attribute returned by LDAP will be used to obtain the username of a user (e.g.: 'uid').
* `LDAP: Field to obtain the user's email:` Specifies which attribute returned by LDAP will be used to obtain the email of a user (e.g.: 'mail').
* `LDAP: Field to obtain the user's full name:` Specifies which attribute returned by LDAP will be used to obtain the full name of a user (e.g.: 'cn').
* `SMTP login`: Login in your SMTP server (e.g. `my-email@gmail.com`).
* `SMTP password`: Your SMTP password.
* `SMTP sender`: Email used to send the emails (e.g. `my-email-sender@gmail.com`).
* `SMTP domain`: The domain of your SMTP server (e.g. `gmail.com`).
* `SMTP server`: Your SMTP server (e.g. `smtp.gmail.com`).
* `SMTP port`: Port used for SMTP (e.g. `587`).
* `Use TLS in SMTP`: Mark if your need to use TLS in SMTP.
* `Auto start TLS in SMTP`:  When set to true, detects if STARTTLS is enabled in your SMTP server and starts to use it.
* `SMTP authentication type`: Authentication type for SMTP (e.g. `login`).
* `Send exception notifications`: Mark if you want to receive emails when an exception occurs in your server.
* `Exception notifications recipients`: List of emails that should receive debug messages.
* `Exception notifications subject prefix`: Prefix used in the subject in debug messages (e.g. `[mconf-web error]`).
* `External help/FAQ page`: Address of any web page that will be linked in the "Help" link at the footer. Can be an external web site and has to include the entire URL with the protocol (e.g. `http://mywebsite.com/mconf-web-help`).
* `Room dial number pattern`: A pattern that is used to help admins generate dial numbers for rooms. If set, when an admins clicks in the button to generate a dial number for a room, it will use this pattern. In the pattern, `x`s are replaced by random numbers (e.g. `732-7xx-xxxx`).
* `Allow users to create new accounts`: When checked, users are able to register in the website. Otherwise all the registering features will be disabled. Useful to disable user registration if other authentication mechanism is in place (e.g. Shibboleth).
* `Moderate users`: When checked, users will be able to register new accounts, but they will only be allowed to access the site once an administrator approves his account. Otherwise the users can freely access the website after registration. Be aware that if there are pending approvals and you uncheck this flag, these users will not be automatically approved!
* `Enable local authentication`: When checked, users are able to sign in using the local authentication. Useful to disable local sign in if other authentication mechanism is in place (e.g. Shibboleth).
* `Moderate spaces`: When checked, all spaces created by users will be unapproved and therefore inaccessible until an administrator approves it. Spaces not yet approved are only visible to the person that created it and have its features very limited. In short, the creator of the space can only view its basic information and change its name and description. Spaces created by administrators are automatically approved.
* `Forbid users from creating spaces`: If checked, users will not be able to create spaces. Only admins will be able to.
* `Enable event module`: Check it to enable the (still unfinished) even module.
* `Maximum size for uploads`: Set a value to restrict the size of files uploaded to Mconf-Web. Includes all files uploaded by users: avatars, space logos and documents in spaces. Notice that this is a "soft limit", imposed only via Javascript. To have a stronger restriction, set this value also on your Apache configurations, see [[Deployment Install Passenger]].


### Web conference configurations

Aside from site-wide configurations, the management area tab shows link to manage spaces, users, and your web conferences servers and rooms. The web conference page will look similar to:

![Configuring the web conference server](https://github.com/mconf/mconf-web/wiki/images/webconference-show.png "Configuring the web conference server")

In this page you can alter your web conference server's information, manage its rooms and also see the current activity in the server. **Note:** currently only one web conference server can be used. Even if you add more servers, all rooms will be created in the first one.

Clicking to edit the web conference server, will are able to alter the following properties:

* `Name`: A name to identify the server internally;
* `URL`: The URL to the API of the server, in the format `http://server.com/bigbluebutton/api`;
* `Security salt`: The shared secret of this server;
* `Version`: The version of the API of the web conference server (`0.8`, `0.9`, etc). This attribute will be fetched automatically from your server once you save its information. You are not able to edit this attribute.
* `String ID`: A string to identify the server internally and use in URLs.

### User permissions

Another important feature is to be able to edit permissions for users. To do that, go to the user management page, find the target user and click in the "edit" icon near his/her name:

![Editing a user](https://github.com/mconf/mconf-web/wiki/images/user-edit.png "Editing a user")

You will see a page where you can edit the information about the user and, in the bottom, you can check a few flags, including giving the user permission to record or making the user a global administrator (he/she will have full control of the website!):

![Page to edit a user](https://github.com/mconf/mconf-web/wiki/images/user-edit2.png "Page to edit a user")


## Configuration files

### Configuring the database (database.yml)

The database is configured in the file `config/database.yml`. This is a standard configuration file used by Rails applications, so you can find plenty of resources about it on the Internet (for example, [this page](http://guides.rubyonrails.org/getting_started.html#configuring-a-database)).

You can also take a look at the examples in our repository:

* [Default example](https://github.com/mconf/mconf-web/blob/v2.0.0/config/database.yml.example): Uses MySQL for all environments (recommended);
* [SQLite3 example](https://github.com/mconf/mconf-web/blob/v2.0.0/config/database.yml.sqlite.example): Example on how to use SQLite3.

### Configuring the application (setup_conf.yml)

This file contains two sections, one with configurations that are loaded at every application startup and other that is used only once when the database is created.

Remember to keep the file indented and formatted as it is. Its format and structure have semantic meaning, so you shouldn't change them. Some of the parameters in this file are mandatory for the application to behave properly, so the application needs to be able to read it at startup.

Read the comments in the example file (`config/setup_conf.yml.example`). If you don't understand what some of the attributes are used for, don't set them. Setting only the attributes defined in the example file is enough, you can then edit the rest of the configurations in the website interface.


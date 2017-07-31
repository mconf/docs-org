---
date: 2017-01-31
title: Developing Mconf-Web
categories:
  - Mconf-Web
  - Development
description: Development instructions for Mconf-Web
type: Document
---

&rarr; _For the development version of Mconf-Web from the branch `master`._

&rarr; _This version uses uses **Rails 4** and **Ruby 2.2.5**._


## Setting up the development environment

### Initial setup

* First, you need to install some system packages used by Mconf-Web:

```bash
$ sudo apt-get install wget make curl git-core libruby aspell-es aspell-en libxml2-dev \
        libxslt1-dev libmagickcore-dev libmagickwand-dev imagemagick libmysqlclient-dev \
        mysql-server zlib1g-dev build-essential libqtwebkit-dev libreadline-dev \
        libsqlite3-dev libssl-dev libffi-dev redis-server 
```

* Then install Ruby. We recommend the use of [rbenv](https://github.com/rbenv/rbenv). You can see below the commands to install everything you need, but first please look at the links pointed below to learn what those tools are used for and how they work:

    * rbenv's [README file](https://github.com/rbenv/rbenv#readme) describes what it is and has instructions on how to install it
    * [ruby-build](https://github.com/rbenv/ruby-build) is a plugin for rbenv used to install rubies. 

    (Note that if you have RVM installed, **you should remove it first!**)

```bash
# Install rbenv
$ git clone git://github.com/rbenv/rbenv.git ~/.rbenv
$ echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bashrc
$ echo 'eval "$(rbenv init -)"' >> ~/.bashrc
$ source ~/.bashrc
# install ruby build
$ git clone git://github.com/rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build
# install ruby
$ rbenv install 2.2.5
$ rbenv rehash
# set this version of ruby as the default (optional) and check it is correct
$ rbenv global 2.2.5
$ rbenv version # > 2.2.5 (set by /home/mconf/.rbenv/version)
# install bundler
$ gem install bundler -v '1.3.5'
$ rbenv rehash
```

* Clone mconf-web:

```bash
$ git clone git://github.com/mconf/mconf-web.git
```

* Install the dependencies:

```bash
$ bundle install
```

* Open MySQL's console (`mysql -u root -p`) to setup your MySQL user and password:

```sql
# change the passwords in the commands below!
CREATE USER "mconf"@"localhost" IDENTIFIED BY "password";
GRANT ALL PRIVILEGES ON mconf_development.* TO "mconf"@"localhost" IDENTIFIED BY "password";
GRANT ALL PRIVILEGES ON mconf_test.* TO "mconf"@"localhost" IDENTIFIED BY "password";
FLUSH PRIVILEGES;
```

* Configuration files. You need to create and edit the files below. They don't exist yet in your repository, but they all have example files in the same directory that can be copied and used. The files are:
  * `config/database.yml`: Configures the database. Use the user `mconf` and the password you configured on MySQL in the step below. See [[this page|Configuration-Files#configuring-the-database-databaseyml]] for more details about it.
  * `config/setup_conf.yml`: Contains the basic configuration data that will be used during the database setup and when the application is initialized. See [[this page|Configuration-Files#configuring-the-application-setup_confyml]] for more details about it.

* Setup the database. It will drop and recreate your **development** database and create the seeding data you need to run the application.

```bash
$ bundle exec rake db:setup
```

* Run the command below to start the server:

```bash
$ bundle exec rails server
```

* Open your browser and go to `localhost:3000` to access the application. Log in with the admin user you configured on you `setup_conf.yml`.

## Fake test data

You can create fake data in your development database using the following rake task:

```bash
$ bundle exec rake db:populate
```

## Re-creating the database

The easiest way to empty your database and start over again is running the tasks below:

```bash
$ bundle exec rake db:reset
```

If you get an error saying that your database is at the wrong version, just run `db:migrate` once and then try the commands above once again and they should work.


## Testing

Proceed to [[this page|Testing]].

## Development Tips

Proceed to [[this page|Development-Tips]].

## Configuring the website

Mconf-Web stores all its configurations in a database and provides a **management interface** in the website where the admin user can edit most of these configurations. See [[this page|Configuring-the-Website]] for more details.

Also, the configurations that can be edited in the management interface can also be configured using the file `config/setup_conf.yml`. See [[this page|Configuration-Files]] for more details on how it works.


## Development tips

### Sending emails in development

E-mails are sent by `resque` and scheduled by `resque-scheduler`, so you must run the scheduler and (at least) one resque worker:

```bash
$ QUEUE="*" bundle exec rake resque:work
$ bundle exec rake resque:scheduler
```

Don't forget to set your SMTP configurations in the application. And when you modify it, don't forget to restart the web server and all resque processes.


### Testing and modifying emails: MailCatcher

[MailCatcher](http://mailcatcher.me/) is a gem used to "capture" emails and shows them in a simple interface. Very useful when modifying emails in development.

Install it:

```bash
$ bundle install
$ rbenv rehash
```

Run it:

```bash
$ mailcatcher
```

From inside a VM set up with Vagrant, run it with:

```bash
$ mailcatcher --http-ip=0.0.0.0
```

Configure the application with the following SMTP configurations:

* SMTP sender: anything, as long as it's a valid e-mail
* SMTP domain: `localhost`
* SMTP port: `1025`
* Leave all the other SMTP options blank.

Run the resque workers and the scheduler as described in [this section](https://github.com/mconf/mconf-web/wiki/Development-Tips#sending-emails-in-development).

Now all emails sent by Mconf-Web will go to the SMTP server created by MailCatcher and will be available on its interface at [http://localhost:1080/](http://localhost:1080/).

### Updating the list of meetings:

Meetings in Mconf-Web are instances of the model `BigbluebuttonMeeting`.

BigbluebuttonRails uses [resque](https://github.com/defunkt/resque) to schedule workers that will created meetings when a user joins a room. These workers run in background, and need resque to be triggered for then to actually work:

```bash
$ rake resque:work QUEUE='*'
```

Read more at [BigbluebuttonRails README](https://github.com/mconf/bigbluebutton_rails/blob/master/README.rdoc#updating-the-list-of-meetings).

### Using a fake LDAP server on development

There's a rake task called `ldap:server` which after invoked starts a LDAP server in localhost with the same config options as the ones in your database.

```bash
$ bundle exec rake ldap:setup_site # configure the LDAP attributes in your site
$ bundle exec rake ldap:server
```

By default there's only one registered user with login `mconf-user` and password `mconf`.

You can supply a port number with:

```bash
$ bundle exec rake ldap:server[4141]
```

If not present it will use the port configured for the website or 1389.

Recommended site configurations:

* LDAP: Enable authentication: _--check--_
* LDAP: Server IP or domain: `localhost`
* LDAP: Server port: `1389`
* LDAP: Full DN or user to bind: `cn=admin,cn=TOPLEVEL,dc=example,dc=com`
* LDAP: Password to connect: `admin`
* LDAP: Full DN for the users tree: `ou=USERS,dc=example,dc=com`
* LDAP: Field to obtain the username: `uid`
* LDAP: Field for principal name (unique ID): `mail`
* LDAP: Field to obtain the user's email: `mail`
* LDAP: Field to obtain the user's full name: `cn`


### Using ruby with rbenv

You can easily replace RVM by [rbenv](https://github.com/sstephenson/rbenv).

First make sure you remove RVM (`rvm implode`) and all references to it. Then install rbenv following the guide at their GitHub page.

Install the target ruby (check on [`.ruby-version`](https://github.com/mconf/mconf-web/blob/master/.ruby-version) the version you should install):

```bash
$ rbenv install 1.9.2-p290
$ rbenv rehash
```

Install `bundler`:

```bash
$ gem install bundler
```

And then use `bundle exec` **always** when running ruby commands, for example:

```bash
$ bundle exec rake db:migrate
$ bundle exec rails server
```

rbenv has no gemsets as used in RVM, so you bundler is used to keep track of the gems and the versions that should be used.

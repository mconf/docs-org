---
date: 2017-01-30
title: Installing Mconf-Web
categories:
  - Mconf-Web
description: How to install Mconf-Web in your server
type: Document
---

# Overview

This is a step-by-step guide showing every detail needed to install Mconf-Web. If you have experience deploying a Rails application this guide should look very familiar to you.

Mconf-Web is developed in and targeted to Ubuntu systems. We recommend the use of an specific version of Ubuntu (see below).

The recommended setup for the latest version of Mconf-Web is:

1. [Ubuntu](http://www.ubuntu.com/) 14.04 operating system with a user named `mconf` (do not use `root`).
2. Ruby is installed with [rbenv](https://github.com/rbenv/rbenv).
3. [Phusion Passenger](http://www.modrails.com/) (ruby app server).
4. [Apache 2.4](http://httpd.apache.org/).
5. [MySQL](http://www.mysql.com/) database.

This guide guide will instruct you on how to set up this environment.

Mconf-Web can also be adapted to your needs. It is a Ruby on Rails application, so the deployment process is very similar to the deployment of any other Rails application. It should work on any operating system that has Ruby available (and most of them do). But be aware that changing any of these components will probably require modifications in the configuration files and scripts (and maybe even some code changes). Some things, such as trying out a new version of Ubuntu, shouldn't be troublesome. Be careful if you're doing it, the instructions here were not tested in other environments than the one described above.

# Migrate from 0.8.x

If you are migrating to Mconf-Web 2.x, check these pages for more information:

* [[Migrate from 0.8.1 to 2.0 by installing a new server|Migrate-from-0.8.1-to-2.0-by-installing-a-new-server]] (recommended)
* [[Migrate from 0.8.1 to 2.0 by upgrading your server|Migrate-from-0.8.1-to-2.0-by-upgrading-your-server]]


# Installing Mconf-Web

## System Packages

You need to install some system packages before you can run Mconf-web in production:

```bash
$ sudo apt-get update
$ sudo apt-get install curl make git-core libruby aspell-es aspell-en \
    libxml2-dev libxslt1-dev libmagickcore-dev libmagickwand-dev \
    imagemagick libmysqlclient-dev zlib1g-dev build-essential nfs-common \
    libreadline-dev libffi-dev libcurl4-openssl-dev mysql-server \
    redis-server openjdk-7-jre apache2 libapache2-mod-xsendfile
```

This will install several libraries and a few applications and tools Mconf-Web needs.

You will be prompted to type a password for MySQL's root user in case you don't have MySQL server installed yet. You can choose any password you want. The root user will not be used by Mconf-Web, it will only be used by you to configure MySQL.


## Ruby

Mconf-web uses Ruby **2.2.5**. To install Ruby, we suggest the use of [rbenv](https://github.com/rbenv/rbenv).

But you have other options:

* Using RVM: see [this page](https://rvm.io/rvm/install/).
* Using apt packages.
* From source.

From now on, we will assume you will use rbenv, so if you decide for another method you might have to adapt some of commands in the rest of this guide.

The commands below will show you how to install rbenv. In short, this is what you will be doing:

* Install rbenv
* Install the plugin [ruby-build plugin](https://github.com/rbenv/ruby-build), that will actually be used to install ruby
* Install the target ruby
* Install bundler

**Important: if you have RVM installed, you should remove it first!**

```bash
# Install rbenv
$ git clone git://github.com/rbenv/rbenv.git ~/.rbenv
$ echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bash_profile
$ echo 'eval "$(rbenv init -)"' >> ~/.bash_profile
$ source ~/.bash_profile

# install ruby build
$ git clone git://github.com/rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build

# install ruby
$ rbenv install 2.2.5
$ rbenv rehash

# set this version of ruby as the default and check it is correct
$ rbenv global 2.2.5
$ rbenv version
> 2.2.5 (set by /home/mconf/.rbenv/version)

# install bundler
$ gem install bundler -v '1.7.2'
$ rbenv rehash
```

## Download the application

We'll assume the application is going to be installed at `/var/www/mconf-web/current`. You can change this, but be aware that you might have to adapt several configuration files during the rest of the installation. We'll also assume your user is named `mconf`.

Install git if you don't have it and clone Mconf-Web:

```bash
$ sudo mkdir -p /var/www/mconf-web/current
$ sudo chown mconf:www-data /var/www/mconf-web/current # www-data is for Apache
$ git clone git://github.com/mconf/mconf-web.git /var/www/mconf-web/current
```

Next, change your repository to the version you want to deploy (replace `v2.4.0` by the desired version):

```bash
$ cd /var/www/mconf-web/current
$ git checkout v2.4.0
```

The versions available are the tags available. To see all versions, go to [this page](https://github.com/mconf/mconf-web/tags).

With the repository you can now install the dependencies. Run the commands below:

```bash
$ bundle install --path vendor/bundle --without=development test
```

## Configuration files

There are two files that need to be configured and **they are both required**. At first, copy the example files:

```bash
$ cp /var/www/mconf-web/current/config/setup_conf.yml.example /var/www/mconf-web/current/config/setup_conf.yml
$ cp /var/www/mconf-web/current/config/database.yml.example /var/www/mconf-web/current/config/database.yml
```

See below what you have to edit in `setup_conf.yml` and `database.yml`:

* `database.yml` configures the database, using MySQL by default. You only need to set the variables `username` and `password` (for all environments) with the user that will be used to access MySQL and his password. We recommend a user other than `root` (usually `mconf`). See in the section 4.1. below how to create this user.

* `setup_conf.yml` has general configurations for the web application, some are required when the application is started and some are only used once when creating the database. For the latter, you can also later use Mconf-Web's management interface (see [[this page|Configuring-the-Website]]) to edit them. If you don't edit this file, the default administrator account will have username `admin` and password `admin`.

We suggest that you restrict the permissions to these files, since they will contain sensitive information:

```bash
$ sudo chmod 0600 /var/www/mconf-web/current/config/setup_conf.yml
$ sudo chmod 0600 /var/www/mconf-web/current/config/database.yml
```

To learn more about the other options in these files, see [[this page|Configuration-Files]].





## Database user

This section explains how to create a database for Mconf-Web with a user named `mconf` and give him access to it.

First open MySQL's console (you will have to enter the password for the `root` user):

```bash
$ mysql -u root -p
```

(If you're having trouble with the root password in MySQL, see [this FAQ entry](https://github.com/mconf/wiki/wiki/FAQ#wrong-username-andor-password-for-mysql).)

To create the database run:

```sql
CREATE DATABASE mconf_production;
```

Then create the user (**change all occurrences of `password` below by the actual password**):

```sql
CREATE USER "mconf"@"localhost" IDENTIFIED BY "password";
GRANT ALL PRIVILEGES ON mconf_production.* TO "mconf"@"localhost";
FLUSH PRIVILEGES;
```





## Application configurations

With the configuration files properly set, we'll now set up the database and generate a new [secret key](http://www.railsrocket.com/rake-secret) for the application:

```bash
$ cd /var/www/mconf-web/current
$ RAILS_ENV=production bundle exec rake db:drop db:create db:reset

# This command will change the secret keys used by the application for cookies and
# passwords. It's really important that you do it, otherwise your application will
# use the default values (that are public!) and will be vulnerable.
$ RAILS_ENV=production bundle exec rake secret:reset
```

Then precompile the assets (this might take a few minutes to finish):

```bash
$ bundle exec rake RAILS_ENV=production RAILS_GROUPS=assets assets:precompile
```





## Web server

The web server we use to host Mconf-Web is Apache. We also use [Passenger](http://www.modrails.com/) to server the application together with Apache. So you'll have to install Passenger and use it in the configurations of Apache.

### Passenger with Apache 2.4

Install Passenger (it's a ruby gem) and its module for Apache. Passenger has a nice installer that will compile the Apache module and install it for you. If some dependency is missing it will warn you and help you install it. Run the following commands:

```bash
$ gem install rack:1.5.5 passenger:4.0.59
$ rbenv rehash
$ passenger-install-apache2-module
```
_(Note: we install rack also because newer versions of it require ruby > 2.2.0.)_

The application `passenger-install-apache2-module` is interactive and has the following steps:

1. Check for dependencies: If your system is missing any required software, it will warn you and tell you how to install them. You have to install **all packages suggested!** Simply exit the passenger installer, install the packages and then run the passenger installer again;
2. Ask you which languages you're interested in using Passenger with. You can leave only **ruby** checked.
3. Automatically compile and install the module for Apache;
4. It will show you some lines that must be added the you Apache configuration file. Ignore this for now, the next step of this guide will show you how to configure it.
5. In the last step it will give you an example of how to deploy an application. Ignore the example for now, the next step of this guide will show you the specific configurations for Mconf-web.

Once Passenger has finished installing, enable its module in Apache with:

```bash
$ passenger-install-apache2-module --snippet | sudo tee /etc/apache2/conf-available/mconf-passenger.conf
$ sudo a2enconf mconf-passenger
```

This will create a new configuration file with the Passenger module snippet, the same block Passenger showed you in the last item after the installation.

See more about Passenger at [their website](https://www.phusionpassenger.com/) and [read this guide](http://www.modrails.com/documentation/Users%20guide%20Apache.html) to see more about how it can be used with Apache.

### Apache configurations

By default Apache is installed at `/etc/apache2/` and it's configuration file will be at `/etc/apache2/apache2.conf`.
You can add configuration files at `/etc/apache2/conf-available/` and sites at `/etc/apache2/sites-available/`.

At first we enable some modules in Apache and remove any default site (in case it exists):

```bash
$ sudo a2enmod rewrite
$ sudo a2enmod xsendfile
$ sudo rm /etc/apache2/sites-enabled/*  # be careful if you have something installed already!
```

Now you need to add a configuration file for Mconf-Web. You might just download our example and edit it:

```bash
$ sudo cp /var/www/mconf-web/current/config/webserver/apache2.example /etc/apache2/sites-available/mconf-web.conf
```

The file will be saved at `/etc/apache2/sites-available/mconf-web.conf`.

You should change `YOUR_HOST` by your IP or domain and `/YOUR_MCONF_WEB/public` (both occurrences) to the path to your Mconf-Web application, that should be `/var/www/mconf-web/current/public` (don't forget to point to the **public** directory!).

Review also the `LimitRequestBody` option, that is used to limit the size of files uploaded to Mconf-Web and defaults to 15 MB. You can change it to whatever you want, just remember to also change the option available in the [[management configuration of your site|Configuring the Website]] to the same value you configure on Apache. Notice that Apache uses 2014 as the multiplier for file sizes. This means that, if you set "15 MB" as the maximum file size in Mconf-Web, for example, you need to set "15728640" in Apache. These are some other examples of matching values in Mconf-Web and in Apache:
* 5 MB = 5242880
* 10 MB = 10485760
* 50 MB = 52428800


After editing the file, enable it in Apache with:

```bash
$ sudo a2ensite mconf-web
```

At last, restart Apache and it should be ready to serve Mconf-Web:

```bash
$ sudo service apache2 restart
```

At this point you should already be able to access your application in your browser!






## Monit

[Monit](http://mmonit.com/monit/) is a tool for managing and monitoring processes in UNIX systems. It is installed as packages in your server and configured to monitor some processes needed by Mconf-Web. Monit will make sure all processes related to Mconf-Web are running, and it's your job to make sure that Monit is always running.

Install monit:

```bash
$ sudo apt-get install monit
```

You shouldn't have problems regarding the version of Monit being used, but, for a reference, these instructions have been tested with Monit 5.3.2.

The configuration files Mconf-Web uses for Monit are found in the application's folder `config/monit/`. We will simply include these files in Monit's configuration file, so they are loaded when monit starts. First, open the configuration file with an editor:

```bash
$ sudo vim /etc/monit/monitrc
```

Change the monitoring interval to 1 minute (it usually defaults to 2 minutes):

```
set daemon 60
```

Enable HTTP support by uncommenting the following lines:

```
set httpd port 2812 and
   use address localhost  # only accept connection from localhost
   allow localhost
```

Then install the configuration file:

```bash
sudo cp /var/www/mconf-web/current/config/monit/resque_workers.monitrc /etc/monit/conf.d/resque_workers.monitrc
```

Notice that this file contains the path to the application and the user/group that should be used to run the processes. They are set to use the default folder (`/var/www/mconf-web/current`) and user/group (`mconf:mconf`), but **you should always check them to see if they fit your environment**!


### Managing Monit: start, stop, log files

To start and stop Monit you can simply run:

```bash
$ sudo /etc/init.d/monit stop
$ sudo /etc/init.d/monit start
```

Be aware that stopping Monit will *not* stop the processes it monitors. You have to stop them individually before or after stopping Monit. When you start Monit, however, all processes are started. Monit is also started automatically when your server is started, so all processes will automatically be started.

You can check if the processes being monitored are running with:

```bash
$ ps aux | grep -e resque
```

The response you get should include the processes in the example output below:

```
mconf  13082  0.0 10.5 944220 106708 ?  Sl  Nov08  1:06 resque-1.25.1: Waiting for all
```

To start or stop the processes individually, use:

```bash
# for resque workers: all of them
$ sudo monit -g resque_workers start
$ sudo monit -g resque_workers stop

# for all services
$ sudo monit start all
$ sudo monit stop all
```

If any of the commands above fail with the message `monit: Cannot connect to the monit daemon. Did you start it with http support?`, you need to enable http support on Monit's config file. Open the configuration file at `/etc/monit/monitrc`. Search for a section similar to the one below and uncomment it:

```
set httpd port 2812 and
   use address localhost  # only accept connection from localhost
   allow localhost        # allow localhost to connect to the server and
```

### Log files

Monit's log file is located at `/var/log/monit.log`. The log files for the processes it monitors are at:

```bash
/var/www/mconf-web/current/log/resque_workers_all.log
/var/www/mconf-web/current/log/resque_scheduler.log
```







## Logrotate



[Logrotate](http://linuxcommand.org/man_pages/logrotate8.html) is a utility that prevents logs from getting too big by creating new files and compacting the old ones.

You server should already have it installed, but if it doesn't, install it with:

```bash
$ sudo apt-get install logrotate
```

The configuration file for logrotate can be copied from Mconf-Web's repository with:

```bash
$ sudo cp /var/www/mconf-web/current/config/logrotate/mconf-web /etc/logrotate.d/mconf-web
```

If you have Mconf-Web installed in a path other than `/var/www/mconf-web/current`, you will have to edit the  application path in the configuration file above.

Then set the permissions and activate logrotate:

```bash
$ sudo chown root:root /etc/logrotate.d/mconf-web
$ sudo chmod 644 /etc/logrotate.d/mconf-web
$ sudo logrotate -s /var/lib/logrotate/status /etc/logrotate.d/mconf-web
```

If the last command doesn't print any errors, it should be working. Check the `log` folder inside your Mconf-Web to see if the log files have been changed.







## Done!

At this point you finished installing Mconf-Web. The first thing you might want to do is [[access the application and configure it|Configuring-the-Website]].




# Maintenance tasks

## Restart

To restart the application you need to restart the web server and all processes being monitored:

```bash
$ sudo service apache2 restart
$ sudo /etc/init.d/monit restart
$ sudo monit restart all
```

The web server you'll need to restart every time you change anything in the application (source code) or configuration files. You don't always need to restart Monit, only if you changed anything in its configuration files or in files that the monitored processes use (for example, if you change the Gmail account settings used to send emails). If you're not sure, restart it.


## Backup

The most important backup you need is your database. If you're using MySQL, you can use the following commands to backup (and restore) the database used by Mconf-Web:

```bash
# backup: dump the database to a .sql file
$ mysqldump -u root -p mconf_production > mconf_production-`date +%F`.sql

# restore: load the .sql file
$ mysql -u root -p mconf_production < mconf_production-2011-06-21.sql
```

There are also files that are not stored in the database, such as user avatars and attachments. And you also might want to backup your log files. So make sure you back up the files in the following folders:

```bash
/var/www/mconf-web/current/private/uploads/
/var/www/mconf-web/current/public/uploads/
/var/www/mconf-web/current/log/
```


## Update

**Important**: These instructions are only valid if you are updating your version from Mconf-Web 2.0 to newer 2.x versions. If you are upgrading from previous versions of Mconf-Web to 2.x, check the section [Migrate from 0.8.x](#migrate-from-08x).

At first, update your repository and get the version you want (replace `v2.4.0` by the desired version):

```bash
$ cd /var/www/mconf-web/current
$ git pull
$ git checkout v2.4.0
```

Update the dependencies:

```bash
$ bundle install --without=development test
```

Migrate the database:

```bash
$ RAILS_ENV=production bundle exec rake db:migrate
```

Recompile the assets:

```bash
$ bundle exec rake RAILS_ENV=production RAILS_GROUPS=assets assets:precompile
```

There are also other files that might need to be updated, such as the configuration files for Monit, that will not be configured with the commands above. To check if you need to do any extra work, look at the update notes in the [changelog](https://github.com/mconf/mconf-web/blob/master/CHANGELOG.md).

Restart the web server as described previously.

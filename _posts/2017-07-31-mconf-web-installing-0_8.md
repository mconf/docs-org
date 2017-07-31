---
date: 2017-01-30
title: Installing Mconf-Web (version 0.8)
categories:
  - Mconf-Web
  - Installation
description: How to install Mconf-Web 0.8 in your server
type: Document
---

&rarr; _For Mconf-Web version 0.8_.

This is a step-by-step guide showing every detail needed to install Mconf-Web 0.8. If you have experience deploying a Rails application this guide should look very familiar to you.

Mconf-Web is developed in and targeted to Ubuntu systems. We recommend the use of an specific version of Ubuntu (see below), but it has been tested in newer versions and should work as well (however some instructions might have to be adapted).

The recommended setup for this version of Mconf-Web is:

1. [Ubuntu](http://www.ubuntu.com/) 12.04 operating system with a user named `mconf`.
2. Ruby is installed with [RVM](https://rvm.beginrescueend.com/).
3. [Phusion Passenger](http://www.modrails.com/) (ruby app server).
4. [Apache](http://httpd.apache.org/) (but you can also use [Nginx](http://nginx.net/)).
5. [MySQL](http://www.mysql.com/) database.

This guide will instruct you on how to setup this environment.

Mconf-Web can also be adapted to your needs. It is a Ruby on Rails application, so the deployment process is very similar to the deployment of any other Rails application. It should work on any operating system that has Ruby available (and most of them do). But be aware that changing any of these components will probably require modifications in the configuration files and scripts (and maybe even some code changes).



# Installing Mconf-Web

## System Packages

You need to install some system packages before you can run Mconf-web in production:

```bash
$ sudo apt-get update
$ sudo apt-get install curl make git-core libruby aspell-es aspell-en \
                       libxml2-dev libxslt1-dev libmagickcore-dev \
                       libmagickwand-dev imagemagick libmysqlclient-dev \
                       mysql-server zlib1g-dev build-essential \
                       libreadline-dev nfs-common libcurl4-openssl-dev
```

You will be prompted to type a password for MySQL's root user in case you don't MySQL installed yet.


## Ruby

Mconf-web uses Ruby **1.9.2** (p290). To install Ruby, we suggest the use of RVM (that's how we install ruby in development and production). But you have other options:

* Using RVM (recommended): See [this page](https://rvm.io/rvm/install/). RVM can be installed as single-user or multi-user. For a production environment it is recommended to use the **multi-user** installation.
* Using apt packages: Ruby can also be installed using apt packages in Ubuntu, but unfortunately they are out of date. Installing ruby 1.9.2 would actually install version 1.9.2-p0 instead of 1.9.2-p290. BigBlueButton 0.8 uses a nice script to compile ruby from source and install it as a package that you can [see here](https://code.google.com/p/bigbluebutton/wiki/InstallationUbuntu#2._Install_Ruby).
* From source: You can also download and install ruby manually, similarly to what's done in the script used by BigBlueButton but skipping the packaging. Make sure you use version 1.9.2-p290.


From now on, we will assume you will install ruby with RVM, so if you decide for another method you might have to adapt some commands.

To install RVM run:

```bash
$ curl -L https://get.rvm.io | sudo bash -s stable --without-gems="bundler"
```

This will install the latest version of RVM skipping the gem `bundler`. We skip it because we need to install an specific version later on. In case you have any problems refer to RVM's documentation at https://rvm.io/rvm/install/.

The first thing after the installation is to add your user to the `rvm` group:

```bash
$ sudo adduser mconf rvm # change "mconf" to your username
```

After that, **restart your terminal!** If you don't do that, RVM won't be found and your user's permissions won't be updated.

Before installing ruby, run the command below to see the dependencies RVM requires you to install before ruby. It will show you a `apt-get` command right below the header "For Ruby / Ruby HEAD (MRI, Rubinius, & REE)". Install the packages listed there before proceeding.

```bash
$ rvm requirements
```

Install ruby and create a gemset for Mconf-web:

```bash
$ rvm install 1.9.2-p290
# if you get a "checksum error", run this command again with:
#   rvm reinstall 1.9.2-p290 --verify-downloads 1

$ rvm gemset create mconf
$ rvm use --default 1.9.2-p290@mconf
```

Then install `bundler` in the gemset `global` to be available to all other gemsets:

```bash
$ rvm use 1.9.2-p290@global
$ gem install bundler -v 1.3.4
$ rvm use 1.9.2-p290@mconf
```




## Download the application

Install git if you don't have it and clone Mconf-Web:

```bash
$ mkdir -p ~/mconf-web/current/
$ git clone git://github.com/mconf/mconf-web.git ~/mconf-web/current/
```

Your application will be deployed at `~/mconf-web/current/`, but you can change it if you need to. It is the default path, so it should require less configurations if you don't change it.

The first thing is to mark the `.rvmrc` as trusted (you can read more about [here](https://rvm.io/workflow/rvmrc/)). This is specially useful later on when other processes are executed (`god` and `delayed_job`) and **needs** this to be done:

```bash
$ rvm rvmrc trust ~/mconf-web/current/.rvmrc
```

Next, change your repository to the version you will be deploying:

```bash
$ cd ~/mconf-web/current
$ git checkout v0.8.1
```

With the repository you can now install the dependencies. All dependencies are either gems (and are listed in the Gemfile) or submodules. Run the commands below:

```bash
$ git submodule init
$ git submodule update
$ bundle install --without=development test
```



## Configuration files

There are two files that need to be configured. At first, copy the example files:

```bash
$ cp ~/mconf-web/current/config/setup_conf.yml.example ~/mconf-web/current/config/setup_conf.yml
$ cp ~/mconf-web/current/config/database.yml.example ~/mconf-web/current/config/database.yml
```

See below what you have to edit in `setup_conf.yml` and `database.yml`:

* `database.yml` configures the database and **it must be configured now**. By default, MySQL will be used. You only need to set the variables `username` and `password` (for all environments) with the user that will be used to access MySQL and his password. We recommend a user other than `root` (usually `mconf`). See the section 4.1. below how to create this user.

* `setup_conf.yml` has general configurations for the web application and **it's optional right now**: if you don't edit it now you can edit its properties from Mconf-Web's interface (see [[this page|Configuring-the-Website-v0.8]]). Note: if you don't edit this file, by default the administrator account will use the email `admin@default.com`, login `admin` and password `admin`.

To learn more about the other options in these files, see [[this page|Configuration-Files-v0.8]].




## Database user

This section explains how to create a database user named `mconf` and give him access to the databases used by Mconf-Web.

First open MySQL's console (you will have to enter the password for the `root` user):

```bash
$ mysql -u root -p
```

(If you're having trouble with the root password in MySQL, see [this FAQ entry](https://github.com/mconf/wiki/wiki/FAQ#wrong-username-andor-password-for-mysql).)

Then create the user (**change all occurrences of `password` by the actual password that should be used**):

```sql
CREATE USER "mconf"@"localhost" IDENTIFIED BY "password";
GRANT ALL PRIVILEGES ON mconf_production.* TO "mconf"@"localhost" IDENTIFIED BY "password";
FLUSH PRIVILEGES;
```



## Application configurations

This step consists of everything that was not possible to be done before because we needed the configuration files properly edited.

We'll setup the database and generate a new [secret key](http://www.railsrocket.com/rake-secret) for rails.

(These commands will drop your old database (if any) and create a new one, empty. Be careful if you're running it again after using the application.)

```bash
$ cd ~/mconf-web/current
$ RAILS_ENV=production bundle exec rake db:drop db:create db:reset
$ sed -i "s/secret_token =.*/secret_token = '`RAILS_ENV=production bundle exec rake secret | sed -n 2p`'/g" ./config/initializers/secret_token.rb
```



## Web server

Mconf-Web uses **Apache** and [**Passenger**](http://www.modrails.com/) to serve the application.

Install Passenger (it's a ruby gem) and its module for Apache. Passenger has a nice installer that will compile the Apache module and install it for you. If some dependency is missing it will warn you and help you install it. Run the following commands:

```bash
$ gem install passenger -v 3.0.11    # this version is also defined in the Gemfile
$ passenger-install-apache2-module
```

(In case `passenger-install-apache2-module` is not found, look for it at `/usr/local/rvm/gems/ruby-1.9.2-p290@mconf/bin/` and use its full path in the command above.)

The application `passenger-install-apache2-module` is interactive and has the following steps:

1. Check for dependencies: If your system is missing any required software, it will warn you and tell you how to install them. You have to install **all packages suggested!** Simply exit the passenger installer, install the packages and then run the passenger installer again; If it asks you to install Rake, do so with `gem install rake -v '0.8.7'`.
2. Automatically compile and install the module for Apache;
3. It will show you some lines that must be added the you Apache configuration file. Ignore this for now, the next step of this guide will show you how to configure it.
4. In the last step it will give you an example of how to deploy an application. Ignore the example for now, the next step of this guide will show you the specific configurations for Mconf-web.

See more about Passenger at [their website](http://www.modrails.com/) and [check this video](http://www.modrails.com/videos/passenger.mov) to see more about how it can be used with Apache.


### Apache configurations

By default Apache is installed at `/etc/apache2/` and it's configuration file will be at `/etc/apache2/apache2.conf`.
You can add configuration files at `/etc/apache2/conf.d/` and sites at `/etc/apache2/sites-available/`.

At first, enable the Passenger module in Apache with:

```bash
$ passenger-install-apache2-module --snippet | sudo tee /etc/apache2/conf.d/mconf-passenger
```

This will create a new configuration file with the Passenger module snippet, the same block Passenger showed you in the item 3 in the previous section.

Next, we enable the rewrite module in Apache and remove any default site that might exist:

```bash
$ sudo a2enmod rewrite
$ sudo rm /etc/apache2/sites-enabled/*
```

Now you need to add a configuration file for Mconf-Web. You might just download our example and edit it:

```bash
$ sudo wget https://raw.github.com/mconf/mconf-web/v0.8.1/config/webserver/apache2.example -O /etc/apache2/sites-available/mconf-web
```

The file will be saved at `/etc/apache2/sites-available/mconf-web`. This is the content of this file:

```
<VirtualHost *:80>

  # Shows the maintenance page if it exists
  ErrorDocument 503 /system/maintenance.html
  RewriteEngine On
  RewriteCond %{REQUEST_URI} !\.(css|gif|jpg|png)$
  RewriteCond %{DOCUMENT_ROOT}/system/maintenance.html -f
  RewriteCond %{SCRIPT_FILENAME} !maintenance.html
  RewriteRule ^.*$  -  [redirect=503,last]

  ServerName YOUR_HOST
  DocumentRoot /YOUR_MCONF_WEB/public
  <Directory /YOUR_MCONF_WEB/public>
    AllowOverride all
    Options -MultiViews
  </Directory>
</VirtualHost>
```

You should change `YOUR_HOST` by your IP or domain and `/YOUR_MCONF_WEB/public` (both occurrences) to the path to your Mconf-Web application, that should be `/home/mconf/mconf-web/current/public` (don't forget to point to the **public** directory!).

After editing the file, enable it in Apache with:

```bash
$ sudo a2ensite mconf-web
```

At last, restart Apache and it should be ready to serve Mconf-Web:

```bash
$ sudo service apache2 restart
```

After installing and configuring Apache and Passenger, you should already be able to access your application in your browser!




## God (monitoring tool)

[God](http://god.rubyforge.org/) is a process monitoring framework that Mconf-Web uses to monitor other processes. It is installed as a system-wide application and configured as such. God should be always running, just like your web server will always be running.

Install God and create an RVM wrapper for it, so that it runs with the correct environment setup:

```bash
$ cd ~/mconf-web/current
$ gem install god -v 0.12.1 # this version is also defined in the Gemfile
$ rvm wrapper 1.9.2-p290@mconf bootup god
```

Next, we'll create a configuration file for god at `/etc/god/config`. This file will simply load any other configuration file in the folder `/etc/god/conf.d/`, that will also be created.

```bash
$ sudo mkdir -p /etc/god/conf.d/
$ sudo wget https://raw.github.com/mconf/mconf-web/v0.8.1/config/god/config -O /etc/god/config
```

God is currently used to monitor the process `delayed_job` (used to deliver emails, mostly). So you need to install God's configuration file for delayed_job:

```bash
$ sudo wget https://raw.github.com/mconf/mconf-web/v0.8.1/config/god/delayed_job.god -O /etc/god/conf.d/delayed_job.god
```

This file has a line that points to Mconf-Web's path, so it should be edited to match the path where you will place Mconf-Web. If Mconf-Web is at `/home/mconf/mconf-web/current` you don't need to do anything!

Otherwise, edit the file with your favorite editor or use the following command to edit it (replace `%PATH%` with the actual path):

```bash
$ sudo sed -i 's:^RAILS_ROOT =.*:RAILS_ROOT = "%PATH%":g' /etc/god/conf.d/delayed_job.god

# example:
$ sudo sed -i 's:^RAILS_ROOT =.*:RAILS_ROOT = "/home/mconf/mconf-web/current":g' /etc/god/conf.d/delayed_job.god
```

Read the next section to see how to start God.

### Managing God: start, stop, status

To start and stop God, we'll install an init script in `/etc/init.d/`:

```bash
$ sudo wget https://raw.github.com/mconf/mconf-web/v0.8.1/config/god/init_script -O /etc/init.d/god
$ sudo chmod a+x /etc/init.d/god
$ sudo update-rc.d god defaults
```

This script is already configured to load the configuration file `/etc/god/config` and save the log at `/var/log/god.log`. The pid file will be at `GOD_PID=/var/run/god.pid`.

Then you can start/stop god with:

```bash
$ sudo /etc/init.d/god {start|stop|terminate|restart|status}
```

Start it, check if it's running. If not, check the messages in the log file:

```bash
$ sudo /etc/init.d/god start
$ ps aux | grep god
```

The `ps` command above should show a process similar to:

```bash
root     28309  9.5  4.2  35808 21380 pts/0    Sl   15:02   0:01 /usr/local/rvm/gems/ruby-1.9.2-p290@mconf/bin/god
```

It's also important to mention that God has two stop commands: `stop` and `terminate`. Using `stop` will finish only God's process, but all monitored processes will not be finished, they will just become unmonitored. The command `terminate` however will stop God and all the monitored processes. `terminate` is usually more useful since it will force processes like `delayed_job` to be finished and then restarted when God is restarted, and this is usually what the user expects when he stops God.


### Updating God to another version

First stop it and uninstall the old version:

```bash
$ sudo /etc/init.d/god terminate
$ gem uninstall god
```

Then run the commands listed in the top of this section to install the new version of god and to create the rvm wrapper.

Make sure the new God is installed, checking the version with:

```bash
$ bootup_god -v
```

Start it again

```bash
$ sudo /etc/init.d/god start
```




## Whenever

[Whenever](https://github.com/javan/whenever) is a gem that helps you configure the crontab. The tasks are specified in the file [config/schedule.rb](https://github.com/mconf/mconf-web/blob/v0.8.1/config/schedule.rb) and then Whenever is used to generate the crontab.

The gem Whenever will already be installed with the other gems when you run `bundle install`, so you just need to use it.

### Updating the crontab

To update the crontab, go to your Mconf-Web directory and run the comman below. It will not override your crontab, only update it with Mconf-Web's entries.

```bash
$ RAILS_ENV=production bundle exec whenever --update-crontab
```

Then look at your crontab with the command below to check if was actually updated:

```bash
$ crontab -l
```

### Whenever with RVM

When using Whenever with RVM, you should add the following line to your `~/.rvmrc`. If the file doesn't exist, create it.

```bash
rvm_trust_rvmrcs_flag=1
```

This prevents cron tasks from failing when trying to read the `.rvmrc` files. For more information check Whenever's [readme file](https://github.com/javan/whenever/blob/master/README.md).





## Logrotate

[Logrotate](http://linuxcommand.org/man_pages/logrotate8.html) is a utility that prevents logs from getting to big creating new files and compacting the old ones.

You server should already have it installed, but if it doesn't, install it with:

```bash
$ sudo apt-get install logrotate
```

The configuration file for logrotate can be copied from Mconf-Web's repository with:

```bash
$ sudo wget https://raw.github.com/mconf/mconf-web/v0.8.1/config/logrotate/mconf-web -O /etc/logrotate.d/mconf-web
```

If you have Mconf-Web installed in a path other than `/home/mconf/mconf-web/current`, you will have to edit the  application path in the configuration file above.

Then set the permissions and activate logrotate:

```bash
$ sudo chown root:root /etc/logrotate.d/mconf-web
$ sudo chmod 644 /etc/logrotate.d/mconf-web
$ sudo logrotate -s /var/lib/logrotate/status /etc/logrotate.d/mconf-web
```

If the last command doesn't print any errors, it should be working. Check the `log` folder inside your Mconf-Web to see if the log files have been changed.




## Done!

At this point you finished installing Mconf-Web. The first thing you might want to do is [[configure the application|Configuring-the-Website-v0.8]].




# Maintenance tasks

## Restart

To restart the application you need to restart the web server and `god`:

```bash
$ sudo service apache2 restart
$ sudo /etc/init.d/god terminate
$ sudo /etc/init.d/god start
```

The web server you'll need to restart every time you change anything in the application (source code) or configuration files.

You don't always need to restart `god`, only if you changed anything in its configuration files or in files that the monitored processes use (for example, if you change the Gmail account settings used to send emails). If you're not sure, restart it. Also, we use the action "terminate" so that `god` will also stop all monitored processes before stopping itself. It will, for instance, stop `delayed_job`  (a gem used to send emails) and then, when `god` is restarted, `delayed_job` will also be restarted (and so your new configurations will be applied).


## Backup

The most important backup you need is your database. If you're using MySQL, you can use the following commands to backup (and restore) the database used by Mconf-Web:

```bash
# backup
$ mysqldump -u root -p mconf_production > mconf_production-`date +%F`.sql

# restore
$ mysql -u root -p mconf_production < mconf_production-2011-06-21.sql
```

There are also files that are not stored in the database, such as user images and attachments. And you also might want to backup your log files.

So make sure you backup the files in the following folders:

```bash
(...)/mconf-web/attachments/
(...)/mconf-web/public/logos/
(...)/mconf-web/log/
```


## Update

Follow the steps below to update from minor versions of 0.8 (e.g. from 0.8 to 0.8.1). **Do not** use it for versions other than 0.8.

At first, update your repository and checkout the version you want:

```bash
$ cd ~/mconf-web/current
$ git pull
$ git checkout v0.8.1
```

Update the dependencies:

```bash
$ git submodule update
$ bundle install --without=development test
```

Migrate the database:

```bash
$ RAILS_ENV=production bundle exec rake db:migrate
```

Update the crontab:

```bash
$ RAILS_ENV=production bundle exec whenever --update-crontab
```

There are also other files that might need to be updated, such as the configuration files for `god`, that will not be configured with the commands above. To check if you need to do any extra work, check the update notes in the [changelog](https://github.com/mconf/mconf-web/blob/master/CHANGELOG.md).

Restart the web server as described previously.

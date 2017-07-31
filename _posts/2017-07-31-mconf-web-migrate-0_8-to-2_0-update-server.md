---
date: 2017-01-31
title: Migrate Mconf-Web 0.8.1 to 2.0 upgrading a server
categories:
  - Mconf-Web
  - Installation
description: Instructions on how to migrate Mconf-Web 0.8.1 to 2.0 by upgrading your server
type: Document
---

## Notes

This guide shows how to migrate from Mconf-Web 0.8.1 to Mconf-Web 2.0. **A lot** was modified in the application and in the server setup and configurations, so read the instructions carefully and be aware that it might take some time to finish all the steps necessary.

If you have the option to install the application in a brand new server and afterwards migrate your old data to it, we recommend you do it, the migration will probably be easier. To do so, follow the guide at: [[Migrate from 0.8.1 to 2.0 by installing a new server]].

If you run into any issue during the migration, first take a look at the "migration notes" at the end of this page, you might find the help you need there. If you need help, contact us on [our mailing list](https://groups.google.com/forum/#!forum/mconf-dev).

## Preparation

### Backup!

Backup everything you can before proceeding, it's the best way to prevent problems. If possible, clone your entire machine and keep it safe in case you need it. If not possible, you should backup at least your database and the application files. More about it [in this page](https://github.com/mconf/mconf-web/wiki/Deployment-v0.8#backup).

### Update your system

Mconf-Web now runs over Ubuntu 14.04. If you use an earlier version of Ubuntu, it is strongly recommended that you upgrade it before installing the new version of Mconf-Web.

To do so, you can use the `do-release-upgrade` command, see more [in this page](https://help.ubuntu.com/14.04/serverguide/installing-upgrading.html).

### Restart your server

Once you upgrade to Ubuntu 14.04, restart your server.

```bash
$ sudo shutdown -r now
```

### Stop the application

```bash
$ sudo /etc/init.d/god terminate
$ sudo service apache2 stop
```

## Migration

Execute the steps below in the order they appear in this guide.

### Install new packages

Install all packages needed by the new version of Mconf-Web following the section "[[System Packages|Deployment#system-packages]]" of the installation manual.

### Replace RVM by rbenv

Mconf-Web now recommends the use of [rbenv](https://github.com/sstephenson/rbenv) instead of RVM to install and use ruby.

At first, remove RVM and everything related to it:

```bash
$ rvm implode --force
```

The command above might show a few warnings that some files could not be removed. If it does, **remove these files yourself**.

If you need more help to remove RVM, there is plenty of information in the Internet. Here are some examples of pages that can help you:

* https://coderwall.com/p/kzlweq
* http://stackoverflow.com/questions/3558656/how-can-i-remove-rvm-ruby-version-manager-from-my-system
* http://stackoverflow.com/questions/3950260/howto-uninstall-rvm

After removing RVM, **restart your terminal!**

Once RVM is properly removed, proceed to the standard installation of rbenv, ruby and bundler, as shown in the section "[[Ruby|Deployment#ruby]]" of the installation guide.

### Update the code to the new version

**Warning:** The commands below will remove any local changes you might have done in your application files. If you did change anything, backup your changes first!

```bash
# cd into your application directory:
$ cd ~/mconf-web/current

$ git fetch --all
$ git checkout v2.0.0
$ git reset --hard origin/v2.0.0
```

### Move the application to `/var/www/mconf-web/`

Previously Mconf-Web was by default installed at `~/mconf-web/current/`. Now this path changed to `/var/www/mconf-web/current/`. We still assume you are deploying using a user named `mconf`.

Move it and make sure you user has permission to access it:

```bash
$ sudo mv ~/mconf-web /var/www/
$ sudo chown -R mconf:www-data /var/www/mconf-web
```

If you have any symbolic links inside the folder `mconf-web`, remember that you will have to recreate them!

Make sure the folders that are used to upload content have permissions that allow it:

```bash
$ sudo chmod -R g+w /var/www/mconf-web/current/public/logos
$ sudo chmod -R g+w /var/www/mconf-web/current/public/uploads
$ sudo chmod -R g+w /var/www/mconf-web/current/private/uploads
```

There are still several configurations that have to be updated to point to this new application path. This will be done in the following sections.

### Update all dependencies

First remove a git submodule that is now installed as a gem:

```bash
$ cd /var/www/mconf-web/current
$ rm -fr .git/modules/vendor/
$ rm -fr vendor/plugins/station/
```

Remove the following lines from the file `.git/config`:

```
[submodule "vendor/plugins/station"]
    url = git://github.com/mconf/station.git
```

Open the file `.bundle/config` and check if it has an entry pointing to the old application path (`~/mconf-web/current`). If it does, change it to the new path `/var/www/mconf-web/current` and save the file.

Install the gems:

```bash
$ bundle install --without=development test
```

### Update your configuration files

The format of the `config/setup_conf.yml` file has changed. Open your file and the [new example file](https://github.com/mconf/mconf-web/blob/v2.0.0/config/setup_conf.yml.example) and compare them. Change the structure of your file to be like the new example file.

You can find more information about it [[in this page|Configuration-Files]].


### Update the database

This is a very important and delicate step in the migration. We recommend [[you backup your database first|Deployment-v0.8#backup]] if you didn't do it yet, so if anything goes wrong you can recover it, solve the errors and try to migrate again.

We will also store the output of this migration into `db-migration.txt`, so you can look at it later on if needed. The command will also output what is happening in your console, so keep an eye open to possible errors in the migration.

```bash
$ RAILS_ENV=production bundle exec rake db:migrate | tee db-migration.txt
```

This migration was tested with different databases with a lot of data in them. But it is always possible that your database will have something unexpected that can break the migration or generate inconsistent data. So keep the `db-migration.txt` for as long as you can, so you can look at it later if needed.

### Compile the assets

This will compile all assets (javascripts and stylesheets) that are used by the clients. It usually takes a few minutes to complete.

```bash
$ RAILS_ENV=production bundle exec rake assets:precompile
```

### Update Passenger and Apache's configurations

First remove the old version of Passenger:

```bash
# if you removed RVM you don't need this next command, all gems have already been removed
$ gem uninstall passenger
```

Then install Passenger and its module for Apache again, following [[this page|Deployment#web-server].

With the new version of Passenger installed, you just have to check Apache's configuration files.

Edit the file `/etc/apache2/sites-available/mconf-web` and, if you enabled HTTPS, the file `/etc/apache2/sites-available/mconf-web-ssl`. The references to the old application path should be updated to `/var/www/mconf-web/current`.

Also verify if your configuration files are similar to the examples we have for Mconf-Web:

* If using Mconf-Web on port 80, without SSL: [this file](https://github.com/mconf/mconf-web/blob/v2.0.0/config/webserver/apache2.example)
* If using Mconf-Web on port 443, with SSL: [this file for port 80](https://github.com/mconf/mconf-web/blob/v2.0.0/config/webserver/apache2_ssl_80.example), [this file for port 443](https://github.com/mconf/mconf-web/blob/v2.0.0/config/webserver/apache2_ssl_443.example)
* If using Mconf-Web with Shibboleth: [this file](https://github.com/mconf/mconf-web/blob/v2.0.0/config/webserver/apache2_shibboleth.example)

### Update Logrotate

Remove the old configuration file:

```bash
$ sudo rm /etc/logrotate.d/mconf-web
```

Install it again [[following the updated guide|Deployment#logrotate]].

### Clean the crontab (`whenever` was removed)

Whenever is a dependency that is not used anymore. It changed your crontab and you won't need these changes anymore, so you should remove them.

Open you `crontab` for edition with:

```bash
$ crontab -e
```

Remove everything in between the marks that Whenever added:

```bash
# Begin Whenever generated tasks for: mconf-web

...

# End Whenever generated tasks for: mconf-web
```

Close the file and your `crontab` will be updated. To check if everything is ok, you can output its content with:

```
crontab -l
```

### Replace God by Monit

Remove God (**be carefull, it will remove all files associated with God!**):

```bash
# if you removed RVM you don't need this next command, all gems have already been removed
$ gem uninstall god

$ sudo rm -r /etc/god/
$ sudo update-rc.d -f god remove
$ sudo rm /etc/init.d/god
```

Install and configure Monit [[following this guide|Deployment#monit]].


### Update the recordings

The structures in which recordings are stored in the database changed, so we need to fetch recordings again from the web conference servers to update the database. This will automatically be done periodically, but you should force an update now to prevent problems.

```bash
$ cd /var/www/mconf-web/current
$ RAILS_ENV=production bundle exec rake bigbluebutton_rails:recordings:update
```

## Database consistency

Some changes in how models are validated might have made some data in your database inconsistent. You can check possible inconsistencies with:

```bash
$ RAILS_ENV=production bundle exec rake db:check_sanity
```

If there are inconsistencies, you can run another rake task that we created to help you fix them:

```bash
$ RAILS_ENV=production bundle exec rake db:sanify
```

This task will search for some common types of inconsistencies and propose a solution to fix them. For each inconsistency found, you can decide whether you want to apply the proposed solution or not. If this task doesn't solve all inconsistencies found, you will have to solve them manually using the Rails console or directly on MySQL's console.

## Final cleanup

When you migrated the database, logos, avatars and attachments were moved to new directories, but the old ones were left where they were. You can now remove them or move them somewhere else:

```bash
$ rm -r /var/www/mconf-web/current/attachments
$ rm -r /var/www/mconf-web/current/public/logos
```

## Restart and test it

Restart your server and, once it comes back, you will be able to access your new version of Mconf-Web.

## Configure

There are new configuration options available in the new version of Mconf-Web that will require your attention. Once you sign in, take some time to visit the management page and look at all the options available.


## Migration notes

More information that might help you with the migration:

* All logos will be moved to a new folder: `public/uploads/`, but the old folder will still be there at `/public/logos/`.
* Attachments were moved from `attachments/` to `/private/uploads/attachments/`. There's a migration to migrate from the old files to the new ones that will make the database consistent, but will not remove obsolete attachments from the disk. The migration has a lot of output messages to indicate attachments that are being removed. Search for the string "attachment being removed from the database (but not from the disk!)" when migrating the database if you want to know the files that can be removed.
* To find possible errors when migrating the logos, search for the string: `error saving the target:`. You shouldn't worry about the warnings `WARN: Migration found a logo without a proper owner, logo will be lost` they are normal (the same logos were stored in several files, one for each resolution; most of them are ignored in the migration, generating this warning).
* The database migration might take some long minutes to finish, depending on how big is your database. The slowest steps are usually these: `GenerateNewLogos`, `RemoveMetadataFromRooms`, `MigrateEventsToMwebEvents`, `CreateRecentActivities`, and `GenerateNewAttachments`.


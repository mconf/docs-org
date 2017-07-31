---
date: 2017-01-31
title: Migrate Mconf-Web 0.8.1 to 2.0 in a new server
categories:
  - Mconf-Web
  - Installation
description: Instructions on how to migrate Mconf-Web 0.8.1 to 2.0 by installing a new server
type: Document
---

This guide will show you how to migrate from Mconf-Web 0.8.1 to Mconf-Web 2.0 by installing a new server with Mconf-Web 2.0 and migrating the data from the old server to the new server server. So the first step in this guide is to create a new server where your new Mconf-Web will be installed. If, for any reason, you can't create a new server and just wish to update your current server, follow this guide: [[Migrate from 0.8.1 to 2.0 by upgrading your server]].


**A lot changed** in the application and in the server setup and configurations, so read the instructions carefully and be aware that it might take some time to finish all the steps necessary.

This guide assumes you don't have any type of customization in your server. If you did change anything (e.g. Apache's configurations), you will need to migrate these changes yourself.


# First step: Install Mconf-Web 2.0

The first step is to install a new version of Mconf-Web 2.0 in a new server. The process is exactly the same as if you were just setting up a new server, so follow the standard installation instructions at: [[Deployment]].

# Second step: Migrate data and files

In this step you will copy the files and the data on your old server's database to the new server.

## Copying the database

Dump the database to a file in the old server:

```bash
$ mysqldump -u root -p mconf_production > ~/mconf_production.sql
# it will ask you for MySQL's root password
```

Copy the file to the new server. You can use `scp` or any other similar command:

```bash
$ ssh mconf@new-server.com
$ scp mconf@old-server.com:~/mconf_production.sql .
```

Drop the database in your new server to prevent conflicts with the data that will be imported:

```bash
$ cd /var/www/mconf-web/current
$ RAILS_ENV=production bundle exec rake db:drop
$ RAILS_ENV=production bundle exec rake db:create
```

Import the database dump into your new server's database:

```bash
$ mysql -u root -p mconf_production < mconf_production.sql
# it will ask you for MySQL's root password
```


## Copy the files

All files uploaded by users to your old server need to be copied to the new server. The folders you need to copy are `attachments` and `public/logos`, including everything inside them. To do so, you can use commands similar to the ones below:

```bash
# signed into your new server, run:
$ rsync -ru --progress mconf@old-server.com:/var/www/mconf-web/current/attachments /var/www/mconf-web/current/
$ rsync -ru --progress mconf@old-server.com:/var/www/mconf-web/current/public/logos /var/www/mconf-web/current/public/
```


## Migrate the database

Since you imported the database from your old server, your current database is in the format used by Mconf-Web 0.8.1, so you will need to update it. This should be done only after you have all the files properly copied to the new server, since this update will also change file names and folders to adapt them to Mconf-Web 2.0.

```bash
$ cd /var/www/mconf-web/current
$ RAILS_ENV=production bundle exec rake db:migrate | tee db-migration.log
```

# Third step: Cleanup

## Update the recordings

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

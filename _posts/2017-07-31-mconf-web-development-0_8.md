---
date: 2017-01-31
title: Developing Mconf-Web 0.8
categories:
  - Mconf-Web
  - Development
description: Development instructions for Mconf-Web 0.8
type: Document
---

&rarr; _For Mconf-Web version 0.8._

&rarr; _This version uses **Rails 3** and **Ruby 1.9.2-p290**._

## Setting up the development environment

### Manual setup

* First, you need to install some system packages used by Mconf-web (you can also see this list of packages [in this file](https://github.com/mconf/mconf-web/blob/v0.8.1/config/packages.ubuntu) in our repository):

    ```bash
$ sudo apt-get install wget make curl git-core libruby aspell-es aspell-en libxml2-dev \
                       libxslt1-dev libmagickcore-dev libmagickwand-dev imagemagick \
                       libmysqlclient-dev mysql-server zlib1g-dev build-essential \
                       libreadline-dev libsqlite3-dev libssl-dev
    ```

* Then install Ruby. We recommend the use of [RVM](http://rvm.beginrescueend.com/). See [this page](http://beginrescueend.com/rvm/install/) to now how to install it (use the single-user installation). After RVM is installed, install Ruby and create a gemset for mconf with:

    ```bash
$ rvm install 1.9.2-p290
$ rvm gemset create mconf
$ rvm use --default 1.9.2-p290@mconf
    ```

* Clone mconf-web and create a branch for version 0.8.1:

    ```bash
$ git clone git://github.com/mconf/mconf-web.git
$ git checkout -b branch-v0.8.1 v0.8.1
    ```

* Install gems and git submodules with:

    ```bash
$ git submodule init
$ git submodule update
$ bundle install
    ```

* Set up your system (it creates some configuration files and updates git submodules):

    ```bash
$ bundle exec rake setup:basic
    ```

* Configuration files. The command above created some files that you need to configure to be able to run the application. They are already formatted with a standard structure, but some information is sensible and unique for each setup, so *you really need* to edit them. The files are:
  * `config/database.yml`: configures the database. See [[this page|Configuration-Files-v0.8#configuring-the-database-databaseyml]] for more details about this file.
  * `config/setup_conf.yml` contains the basic configuration data that will be used during the database setup and when the application is initialized. See [[this page|Configuration-Files-v0.8#configuring-the-application-setup_confyml]] for more details about this file.
  * `config/deploy/conf.yml` configurations for deployment with Capistrano.

* Setup the database. It will drop and recreate your _development_ database, create basic data (<b>you need</b> this data to run the application) and populate the db with test data.

    ```bash
$ bundle exec rake setup:db
    ```

* Run the command below to start the server and open your browser and go to `localhost:3000`.

    ```bash
$ bundle exec rails server
    ```

## Fake test data

You can create fake data in your development database using the following rake task:

```bash
$ bundle exec rake setup:populate
```

It will create users, spaces, posts and everything you need to have a populated web site and test your modifications.

## Testing

Proceed to [[this page|Testing-v0.8]].

## Development Tips

Proceed to [[this page|Development-Tips]].

## Configuring the website

Mconf-Web stores all its configurations in a database and provides a **management interface** in the website where the admin user can edit most of these configurations. See [[this page|Configuring-the-Website-v0.8]] for more details.

Also, the configurations that can be edited in the management interface can also be configured using the file `config/setup_conf.yml`. See [[this page|Configuration-Files-v0.8]] for more details on how it works.

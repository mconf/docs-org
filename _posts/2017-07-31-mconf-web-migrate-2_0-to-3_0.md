---
date: 2017-01-31
title: Migrate Mconf-Web 2.0 to 3.0
categories:
  - Mconf-Web
  - Installation
description: Instructions on how to migrate Mconf-Web 2.0 to 3.0
type: Document
---

***

THIS IS A DRAFT

***

### Upgrade the configuration files

The configuration files moved from:

* `config/setup_conf.yml`: Application configurations and seed data.
* `config/database.yml`: Database configurations.

To:

* `config/seeds.yml`: Seed data only.
* Environment variables or `.env.*` files: Application configurations, including database. `.env` is used in all environments, while `.env.development` is used only in development, `.env.test` only in test, and `.env.production` only in production. If you don't want to use `.env` files you can simply set the environment variables when running the application.

Open the new files and move the configurations from the old files accordingly.

If you don't want to replace `config/seeds.yml`, you can create a `config/seeds.local.yml`, that will take precedence when loading configurations. The same works for `.env` files, you can have `.env.production.local`, for example.
All local files are excluded from git, so use them for configurations only necessary for your local machine when developing or your server when deploying.

To see all available configurations, look at `.env.development`.

---
date: 2017-01-31
title: Testing Mconf-Web
categories:
  - Mconf-Web
  - Development
description: Instructions to test Mconf-Web
type: Document
---

&rarr; _For the development version of Mconf-Web from the branch `master`._

&rarr; _Mconf-Web uses the [rspec framework](http://relishapp.com/rspec) for automated tests._

## Running the tests

To run the tests, first you need to set up your [development environment]({% post_url 2017-07-31-mconf-web-development %}). Then you can run the tests with:

```bash
$ bundle exec rake
```

This command will erase your entire test database, populate it with the seed data (see `db/seeds.rb`) and run *all* tests. It might take some time, but it runs the complete suite of tests to assure that everything is working properly.

Alternatively, you can set up the test database and run single tests to speed up the development.

Run the following command to set up a test database and populate it with the seed data:

```bash
$ RAILS_ENV=test bundle exec rake db:reset
```

Then run the tests using the `rspec` command. The first argument you need to pass to this command is the folder that contains the test files or the files you want to run. You can also specify a single line in a file to run a single test or a block of tests inside a scope. 

```bash
$ bundle exec rspec spec/                            # run all spec inside the folder spec/
$ bundle exec rspec spec/controllers/                # run all spec inside the folder spec/controllers/
$ bundle exec rspec spec/models/space_spec.rb        # run all specs in space_spec.rb
$ bundle exec rspec spec/models/space_spec.rb:40     # run the spec in the line 40 of space_spec.rb
```

Run `rspec --help` for more details.

It is important to run `rspec` with `bundle exec` so that the tests will run using the correct gem environment .

## Running only a few tests

When working on specific parts of the code you can save time by running only some tests pertinent to this part. You can run an specific test or an specific block with:

```bash
$ bundle exec rspec -l 20 spec/models/user_spec.rb
```

This will run the test or block of tests at line 20 in `spec/models/user_spec.rb`.

You can also use tags to identify tests and run just the tests that are tagged. For example:

```bash
# tests for a controller method named "admin"
describe "#admin", :admin => true do
  ...
end
```

To filter the tests that are executed using tags:

```bash
$ bundle exec rspec spec/ --tag @admin      # run all tests with the tag 'admin'
$ bundle exec rspec spec/ --tag ~@abilities # run all except the ones with the tag 'abilities'
```

## Testing migrations

We only test migrations that need to alter data in the DB. Simple migrations don't need to be tested. The instructions here are useful to test a migration before deploying it, but migrations tests don't need to be executed everytime the test suite is executed.

We use `yaml_db` to get the server data and add it to the local database.
The test should apply the migration and test if the data was correctly migrated. The server dump should be in the same version of your current database.

This is a normal workflow to test a migration named `20110101010022_my_migration`. The previous migration is the version 20110101010011. The test will only check if the database state is as it should be after the migration.

```bash
# rollback to the previous version
$ bundle exec rake db:migrate RAILS_ENV=test VERSION=20110101010011

# dump the database and download it
# then load the data in your test DB
$ cap production db:pull
$ bundle exec rake db:data:load RAILS_ENV=test

# if you need to edit your database to add data that should be tested, do it now
# and then store the data so that you can load it later to run the test again
$ bundle exec rake db:data:dump

# migrate to the target version, the migration tested
$ bundle exec rake db:migrate RAILS_ENV=test VERSION=20110101010022

# run the test that will check if the DB is consistent after being migrated
$ bundle exec rspec spec/migrations/my_migration_spec.rb
```

Also, tag your test with `migration_real`:

```bash
context "using real data", :migration_real => true do
  ...
end
```


**Note**: Comment the following lines in your `spec_helper.rb` or your test will not run. We still have to find a better solution for this.

```bash
config.filter_run_excluding :migration => true
config.run_all_when_everything_filtered = true
```

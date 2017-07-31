---
date: 2017-01-31
title: Mconf-Web with vagrant for development
categories:
  - Mconf-Web
  - Development
description: Instructions to use vagrant to develop Mconf-Web
type: Document
---

### Install vagrant

Download and install from https://www.vagrantup.com/downloads.html

Use `1.7.1`. `1.7.2` results in: "Shared folders that Chef requires are missing on the virtual machine". See https://github.com/mitchellh/vagrant/issues/5200

### Dependencies

```bash
sudo apt-get install redir
sudo apt-get install lxc
```

### Install plugins for vagrant

```bash
vagrant plugin install vagrant-lxc
vagrant plugin install vagrant-vbguest
vagrant plugin install vagrant-librarian-chef
vagrant plugin install vagrant-omnibus
```

### Download chef cookbooks

We use `librarian-chef` to download the cookbooks needed and install them locally. Run:

```bash
bundle install
rbenv rehash
librarian-chef install
```

#### Create the VM (~30mins):

```bash
vagrant up
```

### Log into the VM

```bash
vagrant ssh
cd vagrant/
```
From now on you can setup the application as you normally would (e.g. `bundle exec rake db:create`, etc.).

---
date: 2017-08-24
title: Mconf-Web with shibboleth for development
categories:
  - Mconf-Web
  - Development
description: Instructions to enable shibboleth in development in Mconf-Web
type: Document
---

## How-to

Run Mconf-Web in development, access it (`localhost:3000`) and sign in as admin. Go to the management page, click "edit" and check the checkbox `Shibboleth: Enable`.

Edit the following attributes and then save the configurations (the values for the fields below were taken from the the method `test_data` in the file `mconf-web/app/controllers/shibboleth_controller.rb`):

* In 'Shibboleth: Field for email' fill with `Shib-inetOrgPerson-mail`
* In 'Shibboleth: Field for name' fill with `Shib-inetOrgPerson-cn`
* In 'Shibboleth: Field for principal name (unique ID)' fill with `Shib-inetOrgPerson-mail`
* In 'Shibboleth: Environment variables' fill with `Shib.*`

Open `mconf-web/app/controllers/shibboleth_controller.rb` and add the function `test_data` as the first call inside the `load_shib_session` function.

## Details

In production, all the Shibboleth protocol is implemented by modules installed in Apache (`mod_shib`).
They will handle all the communication and all Mconf-Web needs to do is read the user data from environment variables after the user authenticates.

In development, however, there is no Apache to do all the communication, so we need to fake it.
The method `test_data` simulates what `mod_shib` does after the user authenticates: it sets several environment variables with data such as the user's name and email.
So by calling `test_data` in a place **before** Mconf-Web actually deals with the data, we can pretend a user is signing in via Shibboleth.

The rest of the configurations done above (setting the attributes in the management page) are done for production also.
That's because we need to tell Mconf-Web from which environment variables it should read the user data.
So these variables should be the same as the ones set in `test_data`, however they are called.

---
date: 2017-08-24
title: Mconf-Web with shibboleth for development
categories:
  - Mconf-Web
  - Development
description: Instructions to habilit shibboleth to develop Mconf-Web
type: Document
---

### Habilit Shibboleth

* Enter in the portal accessing localhost/3000 as an admin
* In the Menu click in Manage
* Stay in General tab, click to Edit and check the checkbox 'Shibboleth: Enable'

OBS: The values for the fields below were taken from the file 'mconf-web/app/controllers/shibboleth_controller.rb (def test_data)'

-> In 'Shibboleth: Field for email' fill with "Shib-inetOrgPerson-mail"
-> In 'Shibboleth: Field for name' fill with "Shib-inetOrgPerson-cn"
-> In 'Shibboleth: Field for principal name (unique ID)' fill with "Shib-inetOrgPerson-mail"
-> In 'Shibboleth: Environment variables' fill with "Shib.*"

* Save it

* Go to 'mconf-web/app/controllers/shibboleth_controller.rb and add the function 'test_data' in the 'load_shib_session' function
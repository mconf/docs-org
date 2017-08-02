---
date: 2017-01-30
title: Translating Mconf-Web
categories:
  - Mconf-Web
description: How to translate Mconf-Web into your language
type: Document
---

We use Transifex to translate Mconf-Web to other languages. To help with the translation, visit <https://www.transifex.com/projects/p/mconf-web/>, create an account and request to be included as a translator to the language you with to translate Mconf-Web to.

The languages maintained by the Mconf team are:

* English
* Portuguese (Brazil)


### Technical information

All the language files are inside the folder `config/locales` and they use the [YAML format](http://guides.rubyonrails.org/i18n.html). There is a folder for each language and each of these folders contains one or more language files. All the files in these folders are automatically loaded when the application starts.

#### Development process

* Both `en` and `pt-br` are updated during the development process. Files are updated directly on GitHub.
* Periodically the files for `en` and `pt-br` are uploaded to Transifex.
* Other languages are translated directly on Transifex.
* Periodically the files for the other languages is downloaded from Transifex and updated into the repository.

#### How to add a new language manually

For French ("fr"), for example:

* Create a directory `config/locales/fr/`;
* Translate all files in `config/locales/en/` and save them in `config/locales/fr/` using the same filename;
* Change the first line in all of the locale files to the new "fr" language (it was "en");
* Add `:fr` to the list of available locales in the application in [config/application.rb](https://github.com/mconf/mconf-web/blob/master/config/application.rb#L52);
* Add the new language and its name to [config/configatron/defaults.rb](https://github.com/mconf/mconf-web/blob/master/config/configatron/defaults.rb#L42).
* Add the `.js` with the locale for moment.js in [app/assets/javascripts/application.js](https://github.com/mconf/mconf-web/blob/master/app/assets/javascripts/application.js#L31).

Note: Grepping for an existent language might help (e.g. `grep "es.419" . -r`).

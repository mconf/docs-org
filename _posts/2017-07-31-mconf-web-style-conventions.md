---
date: 2017-01-31
title: Mconf-Web style conventions
categories:
  - Mconf-Web
  - Development
description: Style conventions for writing code for Mconf-Web
type: Document
---

This page is mostly intended for developers, even though users can report deviations from these rules as bugs.

Includes a collection of best-practices and coding conventions to be followed while writing code for Mconf-Web.

## General

* Indentation: use 2 spaces for *all* files: ruby, html, sass, coffeescript, etc.


## Ruby / Rails

* Use the following style guide for Ruby: https://github.com/bbatsov/ruby-style-guide
* Use the following style guide for Rails: https://github.com/bbatsov/rails-style-guide
* Views: Write all views using [HAML](http://haml.info/).
* Documentation: Use [Space](https://github.com/mconf/mconf-web/blob/master/app/models/space.rb) and [RecentActivity](https://github.com/mconf/mconf-web/blob/master/app/models/recent_activity.rb) as examples of how to document code.


### Internationalization

* Start by reading the [general guide for internationalization on Rails](http://edgeguides.rubyonrails.org/i18n.html#how-to-store-your-custom-translations).
* **Try not to use randomly picked translation keys in the locales!** Try always to use the default key hierarchy Rails uses to look up for strings. You can find examples in the subsections below.

#### Model names and attributes

Translate only the fields that are used in the application (some attributes might never appear in any form, for example). The translation doesn't need to be literal, but should describe the attribute the best way possible.

Using the default keys Rails looks for in the locales, model names and attributes should be defined as this example:

```yaml
en:
  activerecord:
    models:
      user: "User"
    attributes:
      user:
        full_name: "Full name"
```

See [this guide](http://edgeguides.rubyonrails.org/i18n.html#translations-for-active-record-models) for more details. 

#### Errors on models

Rails looks for error strings in several places. **Any** of the following options are good choices:

```
activerecord.errors.models.user.attributes.name.blank
activerecord.errors.models.user.blank
activerecord.errors.messages.blank
```

See [this guide](http://edgeguides.rubyonrails.org/i18n.html#error-message-scopes) for more details. 

#### Strings for Simple Form

* Attribute names should be defined as commented above in [[#model-names-and-attributes|Style-Conventions#model-names-and-attributes]]
* Errors should be defined as commented above in [[#errors-on-models|Style-Conventions#errors-on-models]]
* Hints are defined in `_simple_form.yml`:

    ```yaml
  en:
    simple_form:
      hints:
        space:
          public: "I'm a hint for the attribute public"
    ```

If you need something else that doesn't fit the items above, follow [Simple Form's definitions for I18n](https://github.com/plataformatec/simple_form#i18n).

See more about Simple Form on Mconf-Web at [[#forms|Style-Conventions#forms]].


#### Lazy lookup

For other strings, **always use [lazy lookup](http://edgeguides.rubyonrails.org/i18n.html#lazy-lookup) inside views**. Lazy lookup will force the keys to be organized the way the application is organized.

Using `t('.name')` inside the view `app/views/user/show.html.erb` will look for the string in:

```yaml
en:
  users:
    show:
      name: "Name"
```

If you can't use lazy lookup, try to organize the keys the same way lazy lookup would organize them. For a string `definition` inside the method `retry` in the controller `SpacesController`, use:

```ruby
class SpacesController < ApplicationController
  def retry
    ...
    message = t('spaces.retry.definition')
    ...
  end
end
```

```yaml
en:
  spaces:
    retry:
      definition: "Definition of a space"
```

#### Generic strings

There are a few very generic strings that can be set only once in the locales, so it doesn't need to be redefined all the time. For these strings, use the block `_other`. Examples:

```yaml
en:
  _other:
    create: "Create"
    destroy: "Destroy"
    details: "Details"
    edit: "Edit"
```

#### Strings in javascript files

Place in the block `_js`. Examples:

```yaml
en:
  _js:
    confirmation_dialog:
      cancel: "Cancel"
      confirm: "OK"
      title: "Confirmation"
```

#### Flash messages

Place strings used in flash messages under a hierarchy `flash:<controller>:<action>`. Examples:

```yaml
en:
  flash:
    users:
      destroy:
        notice: "Removed the user"
        error: "Error removing the user"
      create:
        notice: "Created the user"
```

### Migrations

Do **not** use rails models and their methods in migrations! Avoid this whenever possible. Instead, use the method `execute` to execute raw SQL.

Using rails models in migrations is a time bomb: it will work when the migration is developed, but will most likely fail some day in the future (when models are changed or rails is upgraded, for instance). Moreover, raw SQLs will make the migrations a lot faster, specially for big databases.

Example for simple SQLs:

```ruby
def up
  execute "DELETE FROM bigbluebutton_metadata WHERE owner_type='BigbluebuttonRoom' AND name='mconfweb-title';"
  execute "DELETE FROM bigbluebutton_metadata WHERE owner_type='BigbluebuttonRoom' AND name='mconfweb-description';"
end
```

Example for selects:

```ruby
def up
  logos = ActiveRecord::Base.connection.execute("SELECT * FROM logos")
  logos.each do |logo|
    # logo will be an array, indexed according to how the columns are ordered in the db
    id = logo[0]
    name = logo[2]
    ...
end
```

If you really, really need to use models, another options is to create fake dummy models inside the migration that include only what is needed of that model. In a migration that generates new logos for profiles, you could have a fake `Profile` model with something like:

```ruby
class MyMigration < ActiveRecord::Migration

  # notice that it is inside the migration class, otherwise it will leak
  # to all migrations after it
  class Profile < ActiveRecord::Base
    attr_accessor :crop_x, :crop_y, :crop_w, :crop_h
    mount_uploader :logo_image, LogoImageUploader

    after_create :crop_avatar
    after_update :crop_avatar

    def crop_avatar
      logo_image.recreate_versions! if crop_x.present?
    end
  end

  def up
    profile.logo_image = File.open("image.jpg")
    profile.save
  end

end
```

More info about it:

* http://complicated-simplicity.com/2010/05/using-models-in-rails-migrations/
* https://coderwall.com/p/zav1dg


### Forms

We're using [Simple Form](https://github.com/plataformatec/simple_form) for all forms. You should **always use it** when creating a new form or editing an old one which isn't using it yet.  

Follow the example below:

```haml
  = simple_form_for @space, :html => { :method => :put, :class => 'single-column' } do |f|
    = f.input :name
    = f.input :description, :as => :text, :input_html => { :rows => 5 }
    = f.input :repository
    = f.input :public, :label => t('.public')
    = f.simple_fields_for :bigbluebutton_room do |bbb_room|
      = bbb_room.input :attendee_password, :as => :showable_password
      = bbb_room.input :moderator_password, :as => :showable_password
```

Things to watch out for in the example:

* The less code you have, the better. Knowing how Simple Form works will help you dry the code.
* Most of the times you don't need to explicitly specify an URL for the form, only something like `simple_form_for @space` or `simple_form_for [@space, @event]` will be enough.
* The labels, hints and errors are all set automatically if you define them in the right place in the locale files (see [[#internationalization|Style-conventions#internationalization]]). So you can use `f.input :name` and everything will be set automatically.
* You can set your own strings if necessary, e.g. `f.input :public, :label => t('.public')`. In this case it is there because we want a better description of the attribute specifically in this form.
* There are css classes for different types of forms (e.g. `single-column`) and custom input types (e.g. `showable_password`) already defined in the application. Look for other forms as examples before doing your own.

### Modals

We use [bootstrap modals](http://getbootstrap.com/2.3.2/javascript.html#modals) improved by the lib [bootstrap-modal](https://github.com/jschr/bootstrap-modal). Don't use them directly, always use the wrapper class [`mconf.Modal`](https://github.com/mconf/mconf-web/blob/master/app/assets/javascripts/app/application/modal.js.coffee).

To make a link be opened in a modal window all you need is to set the class `open-modal`. Example:

```haml
= link_to t('.start'), join_options_bigbluebutton_room_path(room),
   :class => "btn btn-primary open-modal", :'data-modal-width' => 'small'
```

You can also see the option `data-modal-width` that forces a different width on the modal. See the comments on `mconf.Modal` for more information.

This class can open remote links (like the example above), content already on the page or even receive content via javascript. See [`mconf.Crop`](https://github.com/mconf/mconf-web/blob/master/app/assets/javascripts/app/application/crop.js.coffee) for an example of how it is called from javascript.

If you need anything that is not provided by `mconf.Modal`, don't do it on your view/js only, do it on `mconf.Modal` so it can be used again later if needed!


### Conventions for views that open as modals

If a view will open in a modal window, it should always be a **partial**. If you want a modal to create a new post, for example, create a view called `posts/_new_post` and add the following to your controller:

```ruby
def new
  respond_to do |format|
    format.html {
      if request.xhr?
        render :partial => "new_post"
      else
        render :new
      end
    }
  end
end
```

The view `posts/new` should render `posts/_new_post` properly adapted to a page that is not a modal. This second view is optional, but it's a nice idea to always have it so the view is properly rendered either inside or outside a modal.



### Links to join webconferencse

Use the class `webconf-join-link`, it will make the conference be opened in a proper window. Example:

```haml
= link_to t('.join'), invite_bigbluebutton_room_path(room), :class => "btn btn-success webconf-join-link"
```


## Coffeescript

* Use this guide: https://github.com/polarmobile/coffeescript-style-guide


## Stylesheets (CSS)

* Use lower-case names separated by `-` for classes names. For example: `new-space-list`.
* CSS classes should describe the content, not the look. For example: `.user-list` is a good name, while `.margin-top` is bad.
* Good resources to follow:
  * https://github.com/stevekwan/best-practices/blob/master/css/best-practices.md



## HTML

* Use lower-case names separated by `-` for IDs. For example: `#user-spaces`.


## Tests

### General

* Read about [RSpec](http://rspec.info/) and best practices. Good resources:
  * http://betterspecs.org/
* **Always** add tests to every code you write. If for some reason you can't, **add [pending examples](https://github.com/dchelimsky/rspec/wiki/Pending-Examples) for everything you've done**, they will at least remind us later of what has to be tested.

### Models

Use the tests for the model Space as an example: https://github.com/mconf/mconf-web/blob/master/spec/models/space_spec.rb

### Controllers

Use the tests for the controller SpacesController as an example: https://github.com/mconf/mconf-web/blob/master/spec/controllers/spaces_controller_spec.rb


# Design Conventions

These are basic guidelines about the design, look 'n feel and the behavior of the web interface of the Mconf Web Portal.

## Tooltips

Helpful text should be placed in tooltips in the elements where they're attached or using icons (see the Icons section below). The function [`options_for_tooltip`](https://github.com/mconf/mconf-web/blob/master/app/helpers/application_helper.rb#L147) can be used to create them without worrying too much with the HTML syntax (see an example [here](https://github.com/mconf/mconf-web/blob/master/app/views/spaces/index.html.haml#L44)).

## Icons

Icons are created using functions inside [`app/helpers/icons_helper.rb`](https://github.com/mconf/mconf-web/blob/master/app/helpers/icons_helper.rb). There's icons for help, more info, comments, news, etc.

You shouldn't never need to define a new icon directly in your view. Always define the icon in the helper and then use it in the view. Check the various methods that are already implemented before creating your own.

All icons use images from [font-awesome](http://fortawesome.github.io/Font-Awesome/icons/) and [boostrap](http://getbootstrap.com/2.3.2/base-css.html#icons).

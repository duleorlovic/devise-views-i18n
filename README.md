# Devise Views I18n

This repo provides setup for Rails internationalisations. It consists of views
for latest devise (4.6.1) and corresponding system tests, i18n setup for Serbian
language (pluralization with few, and accusative form)

# Installation

First you need to have devise installed

```
cat >> Gemfile <<HERE_DOC

# user authentication
gem 'devise'
HERE_DOC
bundle
rails generate devise:install
git add . && git commit -m "rails g devise:install"

rails g devise User
last_migration
# add:
      t.string :name, null: false, default: ''
      t.string :locale, null: false, default: ''
      t.boolean :superadmin, null: false, default: false
# uncomment Trackable and Confirmable and add_index
rake db:migrate
git add . && git commit -m "rails g devise user"
```
Eventual
```
rails g controller pages home --skip-helper --skip-assets
```

By cloning the repo, you will get templates, translation files, helper (for
`login_layout`).

```
git clone git@github.com:duleorlovic/devise-views-i18n.git tmp/devise-views-i18n
# views
cp -r tmp/devise-views-i18n/app/views/devise/ app/views/
# home page
cp tmp/devise-views-i18n/app/views/pages/home.html.erb app/views/pages
# pluralization config
cp tmp/devise-views-i18n/config/initializes/* config/initializers/
# locales
cp tmp/devise-views-i18n/config/locales/* config/locales/
# styles
cp -r tmp/devise-views-i18n/app/assets/stylesheets/* app/assets/stylesheets/
git rm app/assets/stylesheets/application.css
# helper
cp tmp/devise-views-i18n/app/helpers/* app/helpers/
# logo can be created with inkspace
touch app/assets/images/logo.svg
# images
cp -r tmp/devise-views-i18n/app/assets/images/flagpedia.net app/assets/images/
```

Install Bootstrap using yarn and import to application pack

```
yarn add bootstrap jquery popper.js

cat >> app/javascript/packs/application.js <<HERE_DOC
require('bootstrap')
HERE_DOC
```

You need to edit Gemfile since templates use `bootstrap_form_for`.

```
# Gemfile
# bootstrap form
gem 'bootstrap_form'

bundle
```

Copy layout files and check how app/views/layouts/application.html.erb is
updated

```
cp tmp/devise-views-i18n/app/views/layouts/* app/views/layouts/
```

Add route to change locale

```
# config/routes.rb
get '/set_locale', to: 'application#set_locale'
```

Add two methods in controller to set and get locale from session or user and
check how application_controller.rb is updated

```
cp tmp/devise-views-i18n/app/controllers/application_controller.rb app/controllers/application_controller.rb
```

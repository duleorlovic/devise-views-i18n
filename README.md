# Devise Views I18n

This repo provides setup for Rails internationalisations. It consists of views
for latest devise (4.6.1) and corresponding system tests, i18n setup for Serbian
language (pluralization with few, and accusative form)

# Installation

```
rails new myapp
cd myapp
git add .
rubocop --auto-correct # to autocorrent correct some files (except lineLength)
git commit -m'rails new myapp'
```

In the begging we will use generators, but later will will copy all views,
controllers, models to overwrite default. If you skip some column you need to
propagate those changes in those templates...

Lets start with home page
```
rails g controller pages home contact --no-helper --no-assets
```

First you need to have devise installed, but usually for SASS app, users from
same company (club, organization) want to share permissions, so first create
`company` model and than `user` and than `company_users` with position.
```
rails g model company name

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
      # this is reference to currently selected company
      t.references :company, null: false
# uncomment Trackable and Confirmable and add_index

rake db:migrate
git add . && git commit -m "rails g devise user"
```
Generate CompanyUser model
```
rails g model company_users company:references user:references position:string
```

Yard add Bootstrap, stimulus, jbox

```
yarn add bootstrap jquery popper.js
yarn add stimulus jbox select2
yarn add trk_datatables
```

Add usefull gems:

```
cat >> Gemfile <<HERE_DOC

# bootstrap form
gem 'bootstrap_form'

# pick icons by: fontello open; {select icons}; fontello convert
gem 'fontello_rails_converter'

# translation
gem 'mobility', '~> 0.8.6'

# money
gem 'money-rails', '~> 1.12'

# recaptcha for contact form
gem 'recaptcha'

# error notification to EXCEPTION_RECIPIENTS emails
gem 'exception_notification'

# open emails in browser
gem 'letter_opener'

# background job proccessing
gem 'sidekiq'

# index pages with datatables
gem 'trk_datatables'
HERE_DOC
bundle

git add . && git commit -m'Add gems and npm packages'
```

By cloning the repo, you will get templates, translation files, helper (for
`login_layout`).

```
git clone git@github.com:duleorlovic/devise-views-i18n.git tmp/devise-views-i18n
```

Fontello icons that are used are stored in
`tmp/devise-views-i18n/vendor/assets/fonts/config.json` so upload (import) that
on http://fontello.com/ using icon settings. Than download it and move to
`tmp/fontello.zip` and than run
```
mkdir vendor/assets/fonts -p
cp tmp/devise-views-i18n/vendor/assets/fonts/config.json vendor/assets/fonts/
bundle exec fontello convert --no-download
# restart rails server and open http://localhost:3000/fontello-demo.html
gnome-open http://localhost:300`expr $(get_current_viewport) + 1`/fontello-demo.html

# when you want to update you can
fontello open
# select new icons
bundle exec fontello convert

# to create custom logo you can create svg using ruby, but you can also update
vi app/assets/images/logo.svg
# to upload your icon you need to simplify svg, use inkspace or
# https://jakearchibald.github.io/svgomg/

git add . && git commit -m'Using fontello.com icons'
```

Copy files app/views/devise, app/views/pages, app/assets, app/helpers
config/initializers, config/locales

```
rm app/assets/stylesheets/application.css
cp -r tmp/devise-views-i18n/app/* app/
cp -r tmp/devise-views-i18n/config/* config/
cp tmp/devise-views-i18n/db/seeds.rb db/
cp tmp/devise-views-i18n/Procfile .
cp -r tmp/devise-views-i18n/lib/rails lib
cp -r tmp/devise-views-i18n/lib/templates lib
```

For test we need to copy main `test_helper.rb` since it is generated with `rails
new`. For other stuff we use templates.
```
cp -r tmp/devise-views-i18n/test/* test/
```

Check how layouts, config files are updated
```
git diff
```

Those config lines can not be moved to `config/initializers` since I need to
override them for development env
```
# config/application.rb
    config.action_mailer.delivery_method = :smtp
    config.action_view.raise_on_missing_translations = true
    config.active_job.queue_adapter = :sidekiq
    # also check config/initializers/const.rb

# config/environments/development.rb
  config.action_mailer.delivery_method = :letter_opener
  config.generators.assets = false
  config.generators.helper = false
  config.generators.jbuilder = false
```
Some modifications
```
# edit constants
vi config/initializers/const.rb
# edit sidekiq
vi config/sidekiq.yml
# edit site title
vi config/locales/en.yml
# change mailer sender for devise
vi config/initializers/devise.rb
  config.mailer_sender = Rails.application.credentials.mailer_sender
# change mailer sender for application mailers
vi app/mailers/application_mailer.rb
  default from: Rails.application.credentials.mailer_sender
```

Run tests
```
rake
```

When you use scaffold you will get controller and system test, but you also have
example in `test/controllers/admin/users_controller_test.rb` (crud without
new and create), `test/controllers/company_users_controller_test.rb`,
`test/system/my_accounts_test.rb`.

Add credentials to send emails through SMTP, exception notification
```
rails credentials:edit
exception_recipients: my@gmail.com
mailer_sender: My Company <my@gmail.com>

smtp_username: my@gmail.com
smtp_password: mypassword

# captcha https://www.google.com/recaptcha/admin#site/_____?setup
google_recaptcha_site_key: ________
google_recaptcha_secret_key: ________
```

Go to https://myaccount.google.com/u/8/lesssecureapps and enable less secure app
so you can send emails

For heroku you can use this command to configure master key
```
heroku config:set RAILS_MASTER_KEY=`cat config/master.key`

# to reset database instead of
heroku run rails db:migrate:reset DISABLE_DATABASE_ENVIRONMENT_CHECK=1
# you need to use
heroku pg:reset --confirm myapp
```
Seed from fixtures is not supported on heroku psql.

When you generate scaffol for new models, you need to generate datatables
(trk_datatables currently works only for existing/migrated models)

```
rails g scaffold parser name company:references
rake db:migrate
rails g trk_datatables parser # use SINGULAR
vi config/routes.rb # add collection do post :search

vi config/locales/activerecord_actiemodels.sr-lating.yml
# add parser inside models and attributes
yml_google_translate_api.rb config/locales/activerecord_activemodels.sr-latin.yml sr_to_cyr en_humanize
```

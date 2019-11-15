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

First you need to have devise installed, but usually users from same company
(club, organization) want to share permissions, so first create `company` model
and than `user` and than `company_users` with position.
```
rails g model company name
```

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
      # this is reference to currently selected company
      t.references :company, null: false
# uncomment Trackable and Confirmable and add_index

rake db:migrate
git add . && git commit -m "rails g devise user"
```

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

Fontello icons that are used are stored in `vendor/assets/fonts/config.json` so
upload (import) that on http://fontello.com/ using icon settings. Than download
it and move to `tmp/fontello.zip` and than run
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

git add . && git commit -m'Using fontello.com icons'
```

Copy files app/views/devise, app/views/pages, app/assets, app/helpers
config/initializers, config/locales

```
cp -r tmp/devise-views-i18n/app/* app/
cp -r tmp/devise-views-i18n/config/* config/
cp -r tmp/devise-views-i18n/test/* test/
cp tmp/devise-views-i18n/db/seeds.rb db/
cp tmp/devise-views-i18n/Procfile .
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
```
Development config

```
# config/environments/development.rb
  config.action_mailer.delivery_method = :letter_opener
  config.generators.assets = false
  config.generators.helper = false
```
Some modifications
```
git rm app/assets/stylesheets/application.css
# logo can be created with inkspace
touch app/assets/images/logo.svg
# edit constants
vi config/initializers/const.rb
# edit sidekiq
vi config/sidekiq.yml
# edit site title
vi config/locales/en.yml
# change mailer sender for devise
# config.mailer_sender = Rails.application.credentials.mailer_sender
vi config/initializers/devise.rb
# change mailer sender for application mailers
# default from: Rails.application.credentials.mailer_sender
vi app/mailers/application_mailer.rb
```

Add credentials to send emails through SMTP, exception notification
```
rails credentials:edit
mailer_sender: My Company <my@gmail.com>
exception_recipients: my@gmail.com

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

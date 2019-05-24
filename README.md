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

Yard add Bootstrap, stimulus, jbox

```
yarn add bootstrap jquery popper.js
yarn add stimulus jbox
```

Add usefull gems:

```
cat >> Gemfile <<HERE_DOC

# pick icons by: fontello open; {select icons}; fontello convert
gem 'fontello_rails_converter'

# bootstrap form
gem 'bootstrap_form'

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

HERE_DOC
bundle
```

Fontello icons that are used are stored in `config.json` so upload that on
http://fontello.com/ using icon settings and import. Than download it and move
to `tmp/fontello.zip` and than run
```
bundle exec fontello convert --no-download
gnome-open http://localhost:300$(get_current_viewport)/fontello-demo.html

# when you want to update you can
fontello open
# select new icons
bundle exec fontello convert
```

By cloning the repo, you will get templates, translation files, helper (for
`login_layout`).

```
git clone git@github.com:duleorlovic/devise-views-i18n.git tmp/devise-views-i18n
# copy files app/views/devise, app/views/pages, app/assets, app/helpers
# config/initializers, config/locales
cp -r tmp/devise-views-i18n/app/* app/
cp -r tmp/devise-views-i18n/config/* config/
cp -r test/* test/
cp tmp/devise-views-i18n/db/seeds.rb db/
cp tmp/devise-views-i18n/Procfile .
```

Check how layouts, config files are updated
```
git diff
```

Config
```
# config/application.rb
    config.action_view.raise_on_missing_translations = true
    config.action_mailer.smtp_settings = {
      address: 'smtp.gmail.com',
      port: 587,
      domain: 'gmail.com',
      authentication: 'plain',
      enable_starttls_auto: true,
      user_name: Rails.application.credentials.smtp_username!,
      password: Rails.application.credentials.smtp_password!,
    }
    config.action_mailer.delivery_method = :smtp
    config.active_job.queue_adapter = :sidekiq
    # also check config/initializers/const.rb

# config/environments/development.rb
  config.action_mailer.delivery_method = :letter_opener
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
```

Add test helper
```
  # test/test_helper.rb
  def assert_valid_fixture(items)
    assert items.map(&:valid?).all?, (items.reject(&:valid?).map { |c| (c.respond_to?(:name) ? "#{c.name} " : '') + c.errors.full_messages.to_sentence })
  end
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

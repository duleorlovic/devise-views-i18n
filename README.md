# Devise Views I18n

Views for latest devise (4.6.1) but with translated strings.

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
# t.string :name, null: false, default: ''
# t.string :locale, null: false, default: ''
# t.boolean :superadmin, null: false, default: false
# uncomment Trackable and Confirmable and add_index
rake db:migrate
git add . && git commit -m "rails g devise user"
```

By cloning the repo, you will get templates, translation files, helper (for
`login_layout`).

```
git clone git@github.com:duleorlovic/devise-views-i18n.git tmp/devise-views-i18n
# views
cp -r tmp/devise-views-i18n/app/views/devise/ app/views/
# locales
cp tmp/devise-views-i18n/config/locales/* config/locales/
# layouts
cp tmp/devise-views-i18n/app/views/layouts/_login_layout.html.erb app/views/layouts/
cp tmp/devise-views-i18n/app/views/layouts/_flash_notice_alert.html.erb app/views/layouts/
# styles
cp -r tmp/devise-views-i18n/app/assets/stylesheets/* app/assets/stylesheets/
git rm app/assets/stylesheets/application.css
# helper
cp tmp/devise-views-i18n/app/helpers/pages_helper.rb app/helpers/
# logo can be created with inkspace
touch app/assets/images/logo.svg
```

Install Bootstrap using yarn

```
yarn add bootstrap jquery popper.js
```

You need to edit Gemfile since templates use `bootstrap_form_for`.

```
# Gemfile
# bootstrap form
gem 'bootstrap_form'
```

Insert login links in application layout

```
# app/views/layouts/application.html.erb
  <% if login_layout? %>
    <%= render 'layouts/login_layout' %>
  <% else %>
    <body>
      <% if current_user %>
        <div class='text-right pr-2'>
          <strong><%= current_user.email %></strong>
          <%= link_to t('sign_out'), destroy_user_session_path, method: :delete %>
        </div>
      <% else %>
        <div class='text-right pr-2'>
          <%= link_to t('my_devise.sign_in'), new_user_session_path %>
        </div>
      <% end %>
      <%= yield %>
      <%= render 'layouts/flash_notice_alert' %>
    </body>
  <% end %>
```

# Translation

This repo currently contains translations to english and serbian.

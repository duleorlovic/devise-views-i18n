require 'sidekiq/web'
Rails.application.routes.draw do
  root 'pages#home'
  devise_for :users
  authenticate :user, ->(u) { u.superadmin? } do
    mount Sidekiq::Web => '/sidekiq'
  end

  get 'pages/home'
  get 'sign-in-development/:id', to: 'pages#sign_in_development', as: :sign_in_development
  get 'set_locale', to: 'application#set_locale'
  get 'contact', to: 'pages#contact'
  post 'contact', to: 'pages#submit_contact'
  get 'sample-error', to: 'pages#sample_error'
  get 'sample-error-in-javascript', to: 'pages#sample_error_in_javascript'
  get 'sample-error-in-javascript-ajax', to: 'pages#sample_error_in_javascript_ajax'
  post 'notify-javascript-error', to: 'pages#notify_javascript_error'
  get 'sample-error-in-sidekiq', to: 'pages#sample_error_in_sidekiq'

  resource :my_account do
    get :change_email
    get :change_password
    patch :update_password
    get :change_language
    get :edit
    patch :update
  end

  namespace :admin do
    get 'dashboard', to: 'dashboard#index'
    resources :users
  end
end

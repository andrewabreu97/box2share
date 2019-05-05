Rails.application.routes.draw do
  resources :plans
  resources :payments
  resources :subscriptions
  resource :subscription_cart
  devise_for :users, :controllers => { registrations: 'registrations' }
  root 'static_pages#home'
end

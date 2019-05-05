Rails.application.routes.draw do
  get 'payments/show'
  get 'payments/create'
  get 'subscription_carts/show'
  get 'subscription_carts/update'
  resources :plans
  resources :payments
  resources :subscriptions
  resource :subscription_cart
  devise_for :users, :controllers => { registrations: 'registrations' }
  root 'static_pages#home'
end

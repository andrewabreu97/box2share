Rails.application.routes.draw do
  resources :plans
  resources :payments
  resources :subscriptions
  resource :subscription_cart
  devise_for :users, :controllers => { registrations: 'registrations' }
  root 'static_pages#home'
  post "stripe/webhook", to: "stripe_webhook#action"
end

Rails.application.routes.draw do
  get 'panel/home'
  resources :plans
  resources :payments
  resources :subscriptions
  resource :subscription_cart
  devise_for :users, :controllers => { registrations: 'registrations' }
  root 'static_pages#home'
  post "stripe/webhook", to: "stripe_webhook#action"
end

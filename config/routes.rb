Rails.application.routes.draw do
  get 'panel/home'
  resources :plans
  resources :payments
  resources :subscriptions
  resource :subscription_cart
  devise_for :users, :controllers => { registrations: 'registrations' }
  authenticated :user do
    root 'panel#home', as: :authenticated_root
  end
  root 'static_pages#home'
  post "stripe/webhook", to: "stripe_webhook#action"
end

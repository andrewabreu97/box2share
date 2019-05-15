Rails.application.routes.draw do
  resources :plans
  resources :payments
  resources :subscriptions
  resource :subscription_cart
  devise_for :users, :controllers => { registrations: 'registrations' }
  authenticated :user do
    root 'panel#dashboard'
  end
  unauthenticated :user do
    root 'static_pages#home'
  end
  post "stripe/webhook", to: "stripe_webhook#action"
end

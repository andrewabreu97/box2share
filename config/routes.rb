Rails.application.routes.draw do
  get 'subscriptions/destroy'
  resources :plans
  resources :payments
  resources :subscriptions
  devise_for :users, :controllers => { registrations: 'registrations' }
  authenticated :user do
    root 'panel#dashboard'
    get 'panel/plan'
  end
  unauthenticated :user do
    root 'static_pages#home'
  end
  post "stripe/webhook", to: "stripe_webhook#action"
end

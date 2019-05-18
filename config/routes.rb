Rails.application.routes.draw do

  devise_for :users, :controllers => { registrations: 'registrations' }

  authenticated :user do
    root 'panel#dashboard'
  end

  unauthenticated :user do
    root 'static_pages#home'
  end

  get 'panel/plan', to: 'panel#plan'

  post "stripe/webhook", to: "stripe_webhook#action"

  resources :plans
  resources :payments
  resources :subscriptions, path_names: { new: 'new/:plan_id' }

end

Rails.application.routes.draw do

  devise_for :users, :controllers => { registrations: 'registrations' }

  authenticated :user do
    root 'panel#dashboard'
  end

  unauthenticated :user do
    root 'static_pages#home'
  end

  get 'panel/plan', to: 'panel#plan'
  get 'panel/dashboard', to: 'panel#dashboard'

  post "stripe/webhook", to: "stripe_webhook#action"

  resources :plans
  resources :payments
  resources :subscriptions, path_names: { new: 'new/:plan_id' }
  resource :payment_method, except: [:index, :destroy]

end

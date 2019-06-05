Rails.application.routes.draw do

  devise_for :users, :controllers => { registrations: 'registrations' }

  authenticated :user do
    root 'panel#dashboard'
  end

  unauthenticated :user do
    root 'static_pages#home'
  end

  get 'assets/download/:id', to: 'assets#download', as: 'download'
  get 'panel/plan', to: 'panel#plan'
  get 'panel/dashboard', to: 'panel#dashboard'
  get 'panel/files', to: 'panel#files'

  post "stripe/webhook", to: "stripe_webhook#action"

  resources :plans, only: [:index]
  resources :payments, only: [:show]
  resources :subscriptions, path_names: { new: 'new/:plan_id' }

  scope :panel do
    resource :payment_method, only: [:edit, :update]
    resources :assets, except: [:index, :edit, :update]
  end

end

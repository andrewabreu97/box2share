Rails.application.routes.draw do

  devise_for :users, :controllers => { registrations: 'registrations' }

  authenticated :user do
    root 'panel#dashboard'
  end


  unauthenticated :user do
    root 'static_pages#home'
  end

  get "browse/:id" => "folders#browse", :as => "browse"
  get "browse/:id/new_folder", to: "folders#new", as: "new_sub_folder"
  get "browse/:id/new_file", to: "assets#new", as: "new_sub_file"
  get "browse/:id/rename", to: "folders#edit", as: "rename_folder"
  post 'assets/download/:id', to: 'assets#download', as: 'download'
  get 'plan', to: 'panel#plan'
  get 'dashboard', to: 'panel#dashboard'
  get 'files', to: 'panel#files'

  post "stripe/webhook", to: "stripe_webhook#action"

  resources :plans, only: [:index]
  resources :payments, only: [:show, :index]
  resources :subscriptions, path_names: { new: 'new/:plan_id' }

  resource :payment_method, only: [:edit, :update]



  resources :assets, except: [:index]
  resources :folders, except: [:index]

  namespace :admin do
    get "service_statistics", to: "panel#service_statistics"
    resources :users do
      get 'statistics', to: "users#statistics"
    end

  end

end

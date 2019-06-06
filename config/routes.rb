Rails.application.routes.draw do

  devise_for :users, :controllers => { registrations: 'registrations' }

  authenticated :user do
    root 'panel#dashboard'
  end

  unauthenticated :user do
    root 'static_pages#home'
  end

  get "browse/:folder_id" => "folders#browse", :as => "browse"
  get "browse/:folder_id/new_folder", to: "folders#new", as: "new_sub_folder"
  post 'assets/download/:id', to: 'assets#download', as: 'download'
  get 'panel/plan', to: 'panel#plan'
  get 'panel/dashboard', to: 'panel#dashboard'
  get 'panel/files', to: 'panel#files'

  post "stripe/webhook", to: "stripe_webhook#action"

  resources :plans, only: [:index]
  resources :payments, only: [:show]
  resources :subscriptions, path_names: { new: 'new/:plan_id' }

  scope :panel do
    resource :payment_method, only: [:edit, :update]
    resources :assets, except: [:index]
    resources :folders, except: [:index]
  end

end

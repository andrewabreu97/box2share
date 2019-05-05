Rails.application.routes.draw do
  get 'plans/index'
  devise_for :users, :controllers => { registrations: 'registrations' }
  root 'static_pages#home'
end

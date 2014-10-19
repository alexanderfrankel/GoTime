Rails.application.routes.draw do
  root 'home#index'

  get 'auth/:provider/callback', to: 'sessions#create'
  get 'auth/failure', to: redirect('/')
  get 'signout', to: 'sessions#destroy', as: 'signout'

  post 'gotime/authorize', to: 'go_time#create', as: 'authorize'
  get 'gotime/unauthorize', to: 'go_time#destroy', as: 'unauthorize'

  resources :sessions, only: [:create, :destroy]
  resources :home, only: :index
  resources :google_notifications, only: :create
end

Rails.application.routes.draw do
  resources :arts, only: [:index, :show, :create, :update, :destroy]
  resources :statuses, only: [:index]
  post '/register', to: 'users#create'
  post '/login', to: 'sessions#create'
  get '/me', to: 'users#show'
  delete '/logout', to: 'sessions#destroy'
  patch '/password', to: 'passwords#update'
  patch '/reset_password', to: 'password_resets#update'
  get '/reset_password', to: 'password_resets#create'
  patch '/confirmation', to: 'confirmations#update'
end

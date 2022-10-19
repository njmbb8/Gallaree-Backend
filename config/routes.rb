Rails.application.routes.draw do
  resources :arts, only: [:index, :show, :create, :update, :destroy]
  resources :statuses, only: [:index]
  resources :order_items, only: [:create, :destroy, :update]
  resources :order, only: [:show, :index, :update]
  resources :payment_intent, only: [:create, :update]
  resources :addresses, only: [:create]
  resources :bio, only: [:index, :create]
  resources :webhook, only: [:create]
  post '/register', to: 'users#create'
  post '/login', to: 'sessions#create'
  get '/me', to: 'users#show'
  delete '/logout', to: 'sessions#destroy'
  patch '/password', to: 'passwords#update'
  patch '/reset_password', to: 'password_resets#update'
  get '/reset_password', to: 'password_resets#create'
  patch '/confirmation', to: 'confirmations#update'
  post '/add_to_cart/', to: 'order_items#create'
end

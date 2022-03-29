Rails.application.routes.draw do
  resources :arts, only: [:index, :show, :create, :update, :destroy]
  resources :statuses, only: [:index]
  resources :payment_intents, only: [:create]
  resources :order_items, only: [:create, :destroy, :update]
  resources :order, only: [:show, :index]
  resources :payment_intent, only: [:create]
  resources :addresses, only: [:create, :update, :destroy]
  resources :bio, only: [:index, :create]
  post '/register', to: 'users#create'
  post '/login', to: 'sessions#create'
  get '/me', to: 'users#show'
  delete '/logout', to: 'sessions#destroy'
  patch '/password', to: 'passwords#update'
  patch '/reset_password', to: 'password_resets#update'
  get '/reset_password', to: 'password_resets#create'
  patch '/confirmation', to: 'confirmations#update'
  post '/add_to_cart/', to: 'order_items#create'
  post '/webhook', to: 'payment_intent#update'
end

Rails.application.routes.draw do
  resources :arts, only: [:index, :show, :create, :update, :destroy]
  resources :statuses, only: [:index]
  resources :order_items, only: [:create, :update, :destroy]
  resources :order, only: [:show, :index, :update, :destroy]
  resources :checkout_session, only: [:create]
  resources :addresses, only: [:index, :create, :update, :destroy]
  resources :bio, only: [:index, :create]
  resources :webhook, only: [:create]
  resources :card, only: [:index, :create, :destroy]
  resources :setup_intent, only: [:create]
  resources :payment_intent, only: [:index, :create, :update]
  post '/register', to: 'users#create'
  post '/login', to: 'sessions#create'
  get '/me', to: 'users#show'
  delete '/logout', to: 'sessions#destroy'
  patch '/password', to: 'passwords#update'
  patch '/reset_password', to: 'password_resets#update'
  post '/reset_password/', to: 'password_resets#create'
  patch '/confirmation', to: 'confirmations#update'
  post '/add_to_cart/', to: 'order_items#create'
end

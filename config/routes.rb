Rails.application.routes.draw do
  resources :arts, only: [:index, :show, :create, :update, :destroy]
  resources :statuses, only: [:index]
end

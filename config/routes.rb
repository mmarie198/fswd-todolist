Rails.application.routes.draw do
  devise_for :users
  root 'tasks#index'
  
  resources :tasks, only: [:index, :create, :update, :destroy], defaults: { format: :json }
end
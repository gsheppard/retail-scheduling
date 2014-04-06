Dialgus::Application.routes.draw do
  root to: 'home#index'
  devise_for :users

  resources :positions, only: [:index, :create, :show, :destroy]
  resources :employees, only: [:index, :create]
end

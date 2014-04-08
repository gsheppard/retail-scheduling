Dialgus::Application.routes.draw do
  root to: 'home#index'
  devise_for :users

  resources :positions, only: [:index, :create, :show, :destroy]
  resources :employees, only: [:index, :create]
  resources :schedules, only: [:index, :show, :create]

  get 'schedules/week/:sunday', to: 'schedules#week', as: :schedule_week
end

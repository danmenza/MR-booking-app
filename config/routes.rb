Rails.application.routes.draw do
  devise_for :users, controllers: { sessions: "users/sessions" }
  resources :users, only: [:show]
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root to: 'artists#index'
  get 'pages/navigation', to: 'pages#navigation'
  get 'artists/sign-up-confirmation', to: 'artists#confirmation'

  resources :studios, only: [:index, :show, :new, :create]
  resources :artists, only: [:index, :show, :new, :create] do
    resources :reservations, only: [:show, :new, :create]
  end
  get '/users/reservations', to: 'users#reservations'
end

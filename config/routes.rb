Rails.application.routes.draw do
  devise_for :users
  root to: 'artists#index'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  resources :users, only: [:show, :edit, :update, :destroy]
  get 'pages/navigation', to: 'pages#navigation'
  get 'artists/sign-up-confirmation', to: 'artists#confirmation'
  get 'studios/sign-up-confirmation', to: 'studios#confirmation'
  get 'instagram/auth', to: 'artists#auth'
  get 'artists/add-artwork/:id', to: 'artists#add_artwork', as: 'add_artwork'

  resources :studios, only: [:index, :show, :new, :create]
  resources :artists, only: [:index, :show, :new, :update, :create] do
    resources :reservations, only: [:show, :new, :create]
  end
  get '/users/reservations', to: 'users#reservations'
end

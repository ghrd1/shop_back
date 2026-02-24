Rails.application.routes.draw do
  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations'
  }
  
  # User profile routes (for regular users)
  scope :users do
    get 'profile', to: 'users#profile'
    patch 'profile', to: 'users#update_profile'
    put 'profile', to: 'users#update_profile'
  end

  #get '/login', to: redirect('/users/sign_in')
  #get '/logout', to: redirect('/users/sign_out')
  # Admin routes for users management
  resources :users, only: [:index, :show, :update, :destroy]
  
  resources :items
  resources :orders
end

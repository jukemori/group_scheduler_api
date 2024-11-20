Rails.application.routes.draw do
  mount_devise_token_auth_for 'User', at: 'api/v1/auth'
  mount ActionCable.server => '/cable'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  namespace :api do
    namespace :v1 do
      resources :users
      resources :calendars do
        resources :calendar_notes, path: 'notes'
        member do
          get :users
          post :invite
          post :accept_invitation
          post :reject_invitation
          get :notifications
        end
      end
      resources :calendar_invitations, only: [:index]
      post 'events', to: 'events#crud_actions'
      get 'user', to: 'users#show'
    end
  end

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
end

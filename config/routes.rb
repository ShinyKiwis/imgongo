Rails.application.routes.draw do
  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  authenticated :user do
    root to: 'dashboards#show', as: :authenticated_root

    resources :albums do
      resources :attachments, only: [:new, :create, :destroy]
    end
  end

  devise_for :users, skip: [:sessions, :registrations]
  as :user do
    get 'login', to: 'devise/sessions#new', as: :new_user_session
    post 'login', to: 'devise/sessions#create', as: :user_session
    delete 'logout', to: 'devise/sessions#destroy', as: :destroy_user_session
    get 'signup', to: 'devise/registrations#new', as: :new_user_registration
    post 'signup', to: 'devise/registrations#create', as: :user_registration
  end
  root to: redirect('/login')
end

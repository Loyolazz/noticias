Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check

  scope "(:locale)", locale: /pt|es/ do
    root "news#index"

    resources :news, only: %i[index show] do
      resources :comments, only: :create
      resources :ratings, only: :create
    end

    resources :videos, only: %i[index show] do
      resources :comments, only: :create
      resources :ratings, only: :create
    end

    resources :users, only: %i[new create show]
    resource :session, only: %i[new create destroy]
    resources :friendships, only: %i[create destroy]

    namespace :admin do
      resources :news
      resources :videos
      resources :tags, except: :show
      resources :comments, only: %i[index update]
      resources :users, only: :index do
        member do
          patch :ban
          patch :unban
        end
      end
    end
  end
end

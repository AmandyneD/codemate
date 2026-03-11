Rails.application.routes.draw do
  root "pages#home"

  devise_for :users

  resources :users, only: [ :index, :show, :edit, :update ] do
    resources :user_technologies, only: [ :create, :destroy ]
  end

  resources :technologies, only: [ :index, :show ] do
    collection do
      get :search
    end
  end

  resources :projects do
    resources :project_technologies, only: [ :create, :destroy ]
    resources :collaborations, only: [ :create, :index, :update ]
    resources :bookmarks, only: [ :create, :destroy ]
    resources :conversations, only: [ :create, :index ]
  end

  resources :conversations, only: [ :index, :show ] do
    resources :messages, only: [ :create ]
  end

  get "/my/projects", to: "dashboard#projects", as: :my_projects
  get "/my/favorites", to: "bookmarks#index", as: :my_favorites
end

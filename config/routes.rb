Rails.application.routes.draw do
  get "dashboard/projects"
  get "project_technologies/create"
  get "project_technologies/destroy"
  get "user_technologies/create"
  get "user_technologies/destroy"
  get "messages/create"
  get "conversations/index"
  get "conversations/show"
  get "conversations/create"
  get "bookmarks/index"
  get "bookmarks/create"
  get "bookmarks/destroy"
  get "collaborations/create"
  get "collaborations/index"
  get "collaborations/update"
  get "users/index"
  get "users/show"
  get "users/edit"
  get "users/update"
  get "projects/index"
  get "projects/show"
  get "projects/new"
  get "projects/create"
  get "projects/edit"
  get "projects/update"
  root "projects#index"

  devise_for :users

  resources :users, only: [ :index, :show, :edit, :update ] do
    resources :user_technologies, only: [ :create, :destroy ]
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

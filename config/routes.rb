# frozen_string_literal: true

Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: 'application#index'
  
  resources :blog_posts, path: 'blog', only: %i[index show] do
    resources :comments, only: %i[create]
  end
  resources :team_members, path: 'team', only: %i[show]
  resources :board_members, path: 'board', only: %i[show]
  resources :jobs, only: %i[index show]
  
  get 'contact-us', to: 'contact_forms#new', as: :new_contact_forms
  post 'contact-us', to: 'contact_forms#create', as: :contact_forms
  
  post :expire_cache, to: 'application#expire_cache'
end

Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  
  resources :blog_posts, path: 'blog', only: [:index, :show]
end

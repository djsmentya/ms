Rails.application.routes.draw do
  mount RailsAdmin::Engine => '/a', as: 'rails_admin'
  root 'imports#new'
  resource :import, only: %i[new create show]
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end

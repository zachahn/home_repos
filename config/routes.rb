Rails.application.routes.draw do
  resources :projects, param: :name
  resources :users
  resource :session, only: %i[create destroy]
end

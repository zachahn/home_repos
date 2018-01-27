Rails.application.routes.draw do
  resources :projects
  resources :users
  resource :session, only: %i[create destroy]
end

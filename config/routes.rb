Rails.application.routes.draw do
  root to: "projects#index"
  resource :session, only: %i[create destroy]
  resources :projects, param: :name, path: "/" do
    get "objects/:reference(/*path)", to: "objects#show"
    resources :commits, param: :hash, only: [:show]
    resources :branches, param: :name, only: [:index]
  end
end

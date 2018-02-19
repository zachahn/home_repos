Rails.application.routes.draw do
  root to: "projects#index"
  resource :session, only: %i[new create destroy]

  scope format: false, defaults: { format: :html } do
    resources :projects, param: :name, path: "/" do
      get "objects/:reference(/*path)", to: "objects#show", as: :object,
        constraints: { path: /.*/ }
      resources :commits, param: :hash, only: [:show]
      resources :branches, param: :name, only: [:index]
    end
  end

  constraints GrackConstraint.new do
    mount GrackWrapper.new, at: "/"
  end
end

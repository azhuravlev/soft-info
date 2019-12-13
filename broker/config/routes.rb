Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :users, only: [:index, :show, :create, :update, :destroy]
      resources :tools

      root to: "users#index"
    end
  end

  root to: redirect('api/v1')
end

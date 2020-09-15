Rails.application.routes.draw do
  get 'pages/home'
  root to: 'pages#home'
  resources :cocktails do
    resources :doses
    resources :ratings
  end
  resources :doses, only: [:destroy]
  # get '/cocktails', to: 'cocktail#index'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end

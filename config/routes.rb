Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: "accounts#show"
  resource :accounts
  post 'transfer', to: 'accounts#transfer' 
end

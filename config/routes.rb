Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  
  #トップページへのルーティング
  root to: 'toppages#index'
  
  #users/signupでも users/newでもnewページが表示される
  get 'signup', to: 'users#new'
  resources :users, only: [:index, :show, :new, :create]
  
end

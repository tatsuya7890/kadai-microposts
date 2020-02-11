Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  
  #トップページへのルーティング
  root to: 'toppages#index'
  
  #ログイン処理のルーティング
  get 'login', to: 'sessions#new'
  post 'login', to: 'sessions#create'
  delete 'logout', to: 'sessions#destroy'
    
  #users/signupでも users/newでもnewページが表示される
  get 'signup', to: 'users#new'
  
  #ベーシック7セットのうち4つを使用するルーティング
  resources :users, only: [:index, :show, :new, :create] do
    #フォロー中のユーザとフォローされているユーザ一覧表示
    member do
      get :followings
      get :followers
    end
    #collection do
    #  get :search
    #end
  end
  
  
  #新規投稿と削除
  resources :microposts, only: [:create, :destroy]
  #新規フォローとアンフォロー
  resources :relationships, only: [:create, :destroy]

end

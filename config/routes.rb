Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: 'homes#top'
  
  resources :posts do
    resource :post_favorites, only: [:create, :destroy]
    resources :post_comments, only: [:create, :destroy]
  end

  get 'search_tag' => 'posts#search_tag'
  
  resources :users, only: [:show, :edit, :update] do
    member do
      get :favorites
    end
    resource :relationships, only: [:create, :destroy]
      get 'followings' => 'relationships#followings', as: 'followings'
      get 'followers' => 'relationships#followers', as: 'followers'
  end
  
  get 'search_post' => 'posts#search_post'
end
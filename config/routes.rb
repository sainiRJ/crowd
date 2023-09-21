Rails.application.routes.draw do
  get 'rooms/index'
  get 'home/index'
  get 'friendships/new'
  get 'friendships/create'
  get 'friendships/update'
  get 'friendships/show'
  get 'profile/profile'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  # resources :users

  get '/register', to: 'users#new'
  post '/register', to: 'users#create'
  get '/user/verify', to: 'users#verify'
  post '/user/verify', to: 'users#postVerify'
  get '/profile', to: 'profiles#new'
  post '/profile', to: 'profiles#create'
  get '/user', to: 'users#user'
  get '/login', to: 'users#login_form'
  post '/login', to: 'users#login'

  get '/index', to: 'users#index'

  get '/chat', to: 'chats#index'

  resources :users do
    member do
      post 'send_friend_request'
      get 'send_friend_request'

      post 'accept_friend_request'
      get 'accept_friend_request'

      post 'decline_friend_request'
      get 'decline_friend_request'

    end
  end

  resources :friendships, only: [:create, :update]

  post '/send/friend/request/user', to: 'users#send_friend_request'

root 'rooms#index'
post 'chat/create', to: 'chat#create'

get '/signin', to: 'sessions#new'
post '/signin', to: 'sessions#create'
delete '/signout', to: 'sessions#destroy'

resources :rooms
  resources :users

  
resources :rooms do
  resources :messages
end


end

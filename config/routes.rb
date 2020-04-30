class ActionDispatch::Routing::Mapper
  def draw(routes_name)
    instance_eval(File.read(Rails.root.join("config/routes/#{routes_name}.rb")))
  end
end

Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  # resources :wlf, only:[:new,:destroy]
  # root 'test#root'
  draw :api
  root  "form#home"
  # root to: 'user_sessions#login'
  match '/first',to:'test#first',via: "get"
  match '/new',to:'form#new',via:'get'
  match '/create', to:'form#create',via: 'post'
  match '/edit',to: 'form#edit',via:'get'
  match '/update',to:'form#update',via:'post'

  get '/del',to:'form#del'
  post '/save',to:'form#save'
  get '/fill',to:'form#fill'
  get '/show',to:'form#show'
  get '/login',to:'user_sessions#login'
  get '/auth/:provider/callback', :to => 'user_sessions#create'
  get '/auth/failure', :to => 'user_sessions#failure'
  get '/logout', :to => 'user_sessions#logout'
end


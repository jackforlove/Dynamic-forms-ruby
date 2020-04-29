namespace :api, defaults: {format: :json} do
  resources :utils, only: [] do
    get :fetch_s3_url, on: :collection
  end

  resource :version, only:[:show]
end

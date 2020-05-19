namespace :api, defaults: {format: :json} do
  resources :utils, only: [] do
    get :fetch_s3_url, on: :collection
  end

  resource :version, only:[:show]

  resource :mxl,only:[] do
    get '/mxl_get' ,to:"mxl#mxl_get"
    post '/mxl_post',to:"mxl#mxl_post"
    put '/mxl_put',to:"mxl#mxl_put"
    delete '/mxl_delete',to:"mxl#mxl_delete"
  end
end

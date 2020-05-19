class Api::MxlController < ActionController::API
  # include Api::Rescueable
  # include Api::Authenticateable
  # before_action :check_token
  def mxl_get
    retValue={
        "id":1,
        "present_id":0,
        "name":"mxl的api",
        "menthod":"get方式",
        "created_at":Time.now,
        "time_zone":"America/Los_Angeles",
        "link":{
            "title":"我的所有api",
            "post":"http://localhost:3000/api/mxl/mxl_post",
            "get":"http://localhost:3000/api/mxl/mxl_get",
            "put":"http://localhost:3000/api/mxl/mxl_put",
            "delete":"http://localhost:3000/api/mxl/mxl_delete"
        }
    }
    render json: retValue
  end

  def mxl_post
    retValue={
      "id":1,
      "present_id":0,
      "name":"mxl的api",
      "menthod":"post方式",
      "created_at":Time.now,
      "time_zone":"America/Los_Angeles",
      "link":{
          "title":"我的所有api",
          "post":"http://localhost:3000/api/mxl/mxl_post",
          "get":"http://localhost:3000/api/mxl/mxl_get",
          "put":"http://localhost:3000/api/mxl/mxl_put",
          "delete":"http://localhost:3000/api/mxl/mxl_delete"
      }
  }
    retValue["name"]=params[:name]
    render json: retValue
  end

  def mxl_put
    retValue={
        "id":1,
        "present_id":0,
        "name":"mxl的api",
        "menthod":"put方式",
        "created_at":Time.now,
        "time_zone":"America/Los_Angeles",
        "link":{
            "title":"我的所有api",
            "post":"http://localhost:3000/api/mxl/mxl_post",
            "get":"http://localhost:3000/api/mxl/mxl_get",
            "put":"http://localhost:3000/api/mxl/mxl_put",
            "delete":"http://localhost:3000/api/mxl/mxl_delete"
        }
    }
    render json: retValue
  end


  def mxl_delete
    retValue={
        "id":1,
        "present_id":0,
        "name":"mxl的api",
        "menthod":"delete方式",
        "created_at":Time.now,
        "time_zone":"America/Los_Angeles",
        "link":{
            "title":"我的所有api",
            "post":"http://localhost:3000/api/mxl/mxl_post",
            "get":"http://localhost:3000/api/mxl/mxl_get",
            "put":"http://localhost:3000/api/mxl/mxl_put",
            "delete":"http://localhost:3000/api/mxl/mxl_delete"
        }
    }
    render json: retValue
  end
end

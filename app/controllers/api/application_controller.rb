class Api::ApplicationController < ActionController::API
  include Api::Rescueable
  include Api::Authenticateable
  # 前端还是需要添加一个token机制的。
  before_action :check_token

  # dev 环境去除跨域问题
  if Rails.env.development?
    before_action :cors_preflight_check
    after_action :cors_set_headers
  end


  def check_token
    unless current_user
      render json: {message: '您无访问权限！'}, status: 401

      return
    end
  end

  def current_user
    return @current_user if @current_user.present?

    api_key = ApiKey.app.find_by(access_token: get_token)
    @current_user = api_key.user if api_key

    @current_user
  end

  def render_json(data, status: 200)
    unless data.is_a?(Hash)
      data = {data: data}
    end

    render json: data, status: status
  end

  def render_json_error( message: "权限不够", status: 500)
    render json: {message: message}, status: status
  end

  def render_json_list(params, data)
    _data = data.merge({
      errcode: 0,
      page: params[:page] || 1,
      per_page: params[:per_page] || DEFAULT_PERPAGE,
      total_count: params[:total_count]
    })

    render_json(_data)
  end

  def init_page_params
    params[:page] ||= 1
    params[:per_page] ||= DEFAULT_PERPAGE
  end
end
